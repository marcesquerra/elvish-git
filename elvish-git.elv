
fn git [@git-args]{
  try {

    if (eq $git-args [conflicts]) {
      e:git log --graph --decorate --pretty=oneline --abbrev-commit
    } elif (eq $git-args [root]) {
      e:git rev-parse --show-toplevel
    } elif (eq $git-args [conflicts]) {
      e:git ls-files -u | cut -f 2 | sort -u
    } elif (eq $git-args [modified]) {
      e:git ls-files -m | cut -f 2 | sort -u
    } elif (eq $git-args [cd]) {
      cd (e:git rev-parse --show-toplevel)
    } elif (eq $git-args []) {
      e:git
    } else {
      h @rest = $@git-args
      if (eq $h diff) {
        customGitDiff $@rest
      } elif (eq $h new) {
        branch @more = $@rest
        e:git checkout -b $branch
        e:git push --set-upstream origin $branch
      } else {
        e:git $h $@rest
      }
    }

  } except exception {
    fail "git failed"
  }
}
