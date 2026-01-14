xnoremap <localleader>m :<C-u>call OpencodeRunVisual()<CR>

function! OpencodeRunVisual() range abort
  let content = s:get_visual_selection()

  call job_start(['opencode', 'run', content])
endfunction

function! s:get_visual_selection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    if (line2byte(line_start) + column_start) > (line2byte(line_end) + column_end)
        let [line_start, column_start, line_end, column_end] = [line_end, column_end, line_start, column_start]
    endif
    let lines = getline(line_start, line_end)
    if empty(lines)
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection ==# 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction
