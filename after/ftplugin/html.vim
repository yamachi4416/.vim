setlocal iskeyword+=-

if exists('b:match_words')
  setl matchpairs-=<:>
  let b:match_words = substitute(b:match_words, '\V<:>,', '', 'g')
endif
