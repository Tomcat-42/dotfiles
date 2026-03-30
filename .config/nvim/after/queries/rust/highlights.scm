; extends

((line_comment) @comment.todo (#contains? @comment.todo "TODO") (#set! priority 200))
((line_comment) @comment.fixme (#contains? @comment.fixme "FIXME") (#set! priority 200))
((line_comment) @comment.error (#contains? @comment.error "BUG") (#set! priority 200))
((line_comment) @comment.hack (#contains? @comment.hack "HACK") (#set! priority 200))
((line_comment) @comment.xxx (#contains? @comment.xxx "XXX") (#set! priority 200))
((line_comment) @comment.warning (#contains? @comment.warning "WARN") (#set! priority 200))
((line_comment) @comment.note (#contains? @comment.note "NOTE") (#set! priority 200))

((block_comment) @comment.todo (#contains? @comment.todo "TODO") (#set! priority 200))
((block_comment) @comment.fixme (#contains? @comment.fixme "FIXME") (#set! priority 200))
((block_comment) @comment.error (#contains? @comment.error "BUG") (#set! priority 200))
((block_comment) @comment.hack (#contains? @comment.hack "HACK") (#set! priority 200))
((block_comment) @comment.xxx (#contains? @comment.xxx "XXX") (#set! priority 200))
((block_comment) @comment.warning (#contains? @comment.warning "WARN") (#set! priority 200))
((block_comment) @comment.note (#contains? @comment.note "NOTE") (#set! priority 200))
