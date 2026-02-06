vim.opt_local.number = true
vim.opt_local.relativenumber = vim.g.RELATIVENUMBER
vim.opt_local.signcolumn = "no"
vim.opt_local.foldmethod = "manual"

vim.g.netrw_localcopydircmd = "cp -r"
vim.g.netrw_localmovedircmd = "mv -r"
-- These only work for remote operations via SSH/FTP, not local files
vim.g.netrw_rm_cmd = "trash"
vim.g.netrw_rmf_cmd = "trash"
vim.g.netrw_rmdir_cmd = "trash"
vim.g.netrw_list_hide = ".*.swp$,.DS_Store$,*/tmp/*,*.so,*.swp,*.zip,.git/,^..=/=$"
vim.g.netrw_banner = 0

-- Override netrw's delete function with trash for LOCAL files
-- Unfortunately, netrw hardcodes delete() for local files with no config option
-- So we must override the D and <Del> key mappings
vim.cmd([[
  " Function to trash files/directories in netrw
  function! NetrwTrashFiles() range
    " Ensure we're in a netrw buffer
    if !exists("b:netrw_curdir")
      echo "Not in a netrw buffer"
      return
    endif
    
    let curdir = b:netrw_curdir
    let files = []
    let all = 0
    
    " Check if there are marked files
    " netrw uses 2match to highlight marked files, we can check that
    let marked_files = []
    let matches = getmatches()
    
    for m in matches
      if get(m, 'group', '') ==# 'netrwMarkFile'
        " The pattern contains the marked filenames
        " We need to scan the buffer and find which lines match
        let save_cursor = getcurpos()
        let banner_end = exists("w:netrw_bannercnt") ? w:netrw_bannercnt : 0
        
        for lnum in range(banner_end + 1, line('$'))
          let line = getline(lnum)
          " Check if this line matches the mark pattern
          if line =~# m.pattern
            " Parse the filename
            let filename = substitute(line, '\t.*$', '', '')
            let filename = substitute(filename, '^\s*', '', '')
            let filename = substitute(filename, '\s*$', '', '')
            let filename = substitute(filename, '/$', '', '')
            let filename = substitute(filename, '^\%(|\s*\)\+', '', '')
            let filename = substitute(filename, '[@=|\/\*]\+$', '', '')
            
            if filename != "" && filename != ".." && filename != "."
              let fullpath = curdir . "/" . filename
              let fullpath = expand(fullpath)
              if index(marked_files, fullpath) == -1
                call add(marked_files, fullpath)
              endif
            endif
          endif
        endfor
        call setpos('.', save_cursor)
        break
      endif
    endfor
    
    if len(marked_files) > 0
      let files = marked_files
    else
      " Get file under cursor by parsing the current line
      let line = getline(".")
      
      " Skip banner lines
      if exists("w:netrw_bannercnt") && line(".") <= w:netrw_bannercnt
        echo "Cannot delete banner items"
        return
      endif
      
      " Parse filename from netrw line (handles different list formats)
      let filename = substitute(line, '\t.*$', '', '')  " Remove anything after tab
      let filename = substitute(filename, '^\s*', '', '') " Remove leading whitespace
      let filename = substitute(filename, '\s*$', '', '') " Remove trailing whitespace
      let filename = substitute(filename, '/$', '', '')   " Remove trailing /
      let filename = substitute(filename, '^\%(|\s*\)\+', '', '') " Remove tree characters
      
      if filename != "" && filename != ".." && filename != "."
        " Construct full path
        let fullpath = curdir . "/" . filename
        " Expand to handle any ~ or environment variables
        let fullpath = expand(fullpath)
        
        let files = [fullpath]
      else
        echo "No valid file under cursor"
        return
      endif
    endif
    
    if len(files) == 0
      echo "No files to trash"
      return
    endif
    
    " Process files - ask for confirmation unless 'all' is set
    let failed = []
    for file in files
      let ok = ""
      
      if !all
        " Build confirmation prompt
        let filename = fnamemodify(file, ":t")
        
        echohl Statement
        call inputsave()
        let ok = input("Trash <" . filename . ">? [{y(es)},n(o),a(ll),q(uit)] ")
        call inputrestore()
        echohl NONE
        
        if ok == ""
          let ok = "no"
        endif
        
        if ok =~# '^a\%[ll]$'
          let all = 1
        endif
      endif
      
      " Trash the file if confirmed or 'all' is set
      if all || ok =~# '^y\%[es]$'
        let result = system("trash " . shellescape(file))
        if v:shell_error != 0
          call add(failed, file)
        endif
      elseif ok =~# '^q\%[uit]$'
        break
      endif
    endfor
    
    " Clear marked files if we trashed any
    if len(files) > len(failed)
      if exists("s:netrwmarkfilelist_{bufnr('%')}")
        unlet s:netrwmarkfilelist_{bufnr('%')}
      endif
      if exists("g:netrw_markfilelist")
        let g:netrw_markfilelist = []
      endif
    endif
    
    " Show errors if any failed
    if len(failed) > 0
      echohl ErrorMsg
      echo "Failed to trash: " . join(map(failed, 'fnamemodify(v:val, ":t")'), ", ")
      echohl NONE
    endif
    
    " Refresh silently (like netrw does)
    if bufname('%') =~ 'NetrwTreeListing'
      " Tree listing
      edit
    else
      " Regular netrw directory listing
      exe "e " . fnameescape(curdir)
    endif
  endfunction
  
  " Override D and <Del> keys to use trash
  nnoremap <buffer> <silent> D :call NetrwTrashFiles()<CR>
  nnoremap <buffer> <silent> <Del> :call NetrwTrashFiles()<CR>
  vnoremap <buffer> <silent> D :call NetrwTrashFiles()<CR>
  vnoremap <buffer> <silent> <Del> :call NetrwTrashFiles()<CR>
]])
