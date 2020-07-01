call ale#Set('beancount_beancheck_executable', 'bean-check')

function! ale_linters#beancount#beancheck#GetCommand(buffer) abort
    let ret = '%e ' . getbufvar(a:buffer, 'beancount_root', '%t')
    return ret
endfunction

function! ale_linters#beancount#beancheck#Handle(buffer, lines) abort
    let l:pattern = '\v^(.*):(\d+): \s*(.+)$'
    let l:output = []

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        let l:item = {
              \   'filename': l:match[1],
              \   'lnum': l:match[2] + 0,
              \   'text': l:match[3],
              \   'type': 'E',
              \ }

        call add(l:output, l:item)
    endfor

    return l:output
endfunction

call ale#linter#Define('beancount', {
      \   'name': 'beancheck',
      \   'executable': {b -> ale#Var(b, 'beancount_beancheck_executable')},
      \   'command': function('ale_linters#beancount#beancheck#GetCommand'),
      \   'callback': 'ale_linters#beancount#beancheck#Handle',
      \   'read_buffer': 0,
      \   'lint_file': 1,
      \   'output_stream': 'stderr',
      \ })
