;; extends

;; MySQL hash comments
;; Only highlight ERROR nodes that are pure hash comment lines
;; This prevents ERROR nodes from other parsing issues from being highlighted as comments

(ERROR
  (op_unary_other) @comment.line (#eq? @comment.line "#")
  (_)* @comment.line)
