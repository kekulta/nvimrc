" Lox syntax file

if exists("b:current_syntax")
  finish
endif

" keywords
syn keyword loxKeyword class fun var 
syn keyword loxKeyword for while return break continue

" booleans
syn keyword loxBoolean true false

" constants
syn keyword loxConstant nil

" functions
syn keyword loxFunction print 

" operators
syn match loxOperator "\v\*"
syn match loxOperator "\v\+"
syn match loxOperator "\v\-"
syn match loxOperator "\v/"
syn match loxOperator "\v\="
syn match loxOperator "\v!"

" conditionals
syn keyword loxConditional if else and or else

" numbers
syn match loxNumber "\v\-?\d*(\.\d+)?"

" strings
syn match loxSpecialChar "\v\\[tn\\]" contained
syn region loxString start="\v\"" end="\v\"" contains=loxSpecialChar

" comments
syn keyword loxTodo TODO FIXME XXX contained
syn match loxLineComment "\v//.*$" contains=loxTodo,@Spell
syn region loxComment start="/\*" end="\*/" contains=loxComment,loxTodo,@Spell

hi link loxSpecialChar SpecialChar
hi link loxKeyword Keyword
hi link loxBoolean Boolean
hi link loxConstant Constant
hi link loxFunction Function
hi link loxOperator Operator
hi link loxConditional Conditional
hi link loxNumber Number
hi link loxString String
hi link loxLineComment Comment
hi link loxComment Comment
hi link loxTodo Todo

let b:current_syntax = "lox"
