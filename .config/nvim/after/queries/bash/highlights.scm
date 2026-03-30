; extends

((comment) @comment.todo (#contains? @comment.todo "TODO") (#set! priority 200))
((comment) @comment.fixme (#contains? @comment.fixme "FIXME") (#set! priority 200))
((comment) @comment.error (#contains? @comment.error "BUG") (#set! priority 200))
((comment) @comment.hack (#contains? @comment.hack "HACK") (#set! priority 200))
((comment) @comment.xxx (#contains? @comment.xxx "XXX") (#set! priority 200))
((comment) @comment.warning (#contains? @comment.warning "WARN") (#set! priority 200))
((comment) @comment.note (#contains? @comment.note "NOTE") (#set! priority 200))
