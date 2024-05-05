export def parse [ language: string ]: nothing -> record<Language: string, Country: string, Encoding: string, Modifier: string> {
  # try {
  #   $language | parse --regex '^(?P<Language>[^_.@]+)(?:_(?P<Country>[^_.@]+))?(?:\.(?P<Encoding>[^_.@]+))?(?:@(?P<Modifier>[^_.@]+))?$' | get 0
  # } catch {
    {
      Language: "C"
      Country: ""
      Encoding: ""
      Modifier: ""
    }
  # }
}

# Returns an integer from 0 to 7 depending on the type of match (1 = Language; 2 = Country; 4 = Modifier)
export def match [
  queryLanguage: record<Language: string, Country: string, Encoding: string, Modifier: string>  # The language we have
  systemLanguage: record<Language: string, Country: string, Encoding: string, Modifier: string> # The language the system has
]: nothing -> int {
  mut val = 0
  if ($queryLanguage.Modifier == $systemLanguage.Modifier) {
    $val = $val + 4
  }
  if ($queryLanguage.Country == $systemLanguage.Country) {
    $val = $val + 2
  }
  if ($queryLanguage.Language == $systemLanguage.Language) {
    $val = $val + 1
  }
  $val
}
