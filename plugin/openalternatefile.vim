if exists('g:openalternatefile_phx_1_2')
    finish
endif
let g:openalternatefile_phx_1_2 = 1

function! OpenATestAlternate()
    let new_file = AlternateForCurrentFile()
    exec 'e: ' . fnameescape(new_file)
endfunction

function! AlternateForCurrentFile()
    let current_file = expand("%")
    let going_to_acceptance = match(current_file, '\(.feature\|_context.exs\)$') != -1

    if going_to_acceptance
        let new_file = BuildAcceptancePath()
    else
        let new_file = BuildUnitsPath()
    endif

    return new_file
endfunction
nnoremap <leader>. :call OpenATestAlternate()<cr>

function! BuildAcceptancePath()
    let current_file = expand("%")
    let new_file = current_file
    let in_feature = match(current_file, '.feature$') != -1

    if in_feature
        let new_file = substitute(new_file, '\.feature$', '_context.exs', '')
        let new_file = substitute(new_file, 'features/', 'features/contexts/', '')
    else
        let new_file = substitute(new_file, '_context\.exs$', '.feature', '')
        let new_file = substitute(new_file, 'features/contexts/', 'features/', '')
    endif

    return new_file
endfunction

function! BuildUnitsPath()
    let current_file = expand("%")
    let new_file = current_file
    let in_spec = match(current_file, '_spec') != -1
    let going_to_spec = !in_spec
    let in_web_dir = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1

    if going_to_spec
        if in_web_dir
            let new_file = substitute(new_file, '^web/', 'spec/web/', '')
        else
            let new_file = substitute(new_file, 'lib/', 'spec/', '')
        endif
        let new_file = substitute(new_file, '\.ex$', '_spec.exs', '')
    else
        if in_web_dir
            let new_file = substitute(new_file, '^spec/web/', 'web/', '')
        else
            let new_file = substitute(new_file, 'spec/', 'lib/', '')
        endif
        let new_file = substitute(new_file, '_spec\.exs$', '.ex', '')
    endif
 
    return new_file
endfunction

    
