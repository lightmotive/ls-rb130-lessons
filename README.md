# Launch School - RB130 Course - Lessons

Ruby Foundations: More Topics

## Helpful shell scripts

- Create Questions file with specified number of questions:

  ```bash
  touch 'questions.rb'
  printf "# frozen_string_literal: true\n" > "questions.rb"
  for i in {1..10}; do printf "\n# ***\nputs \"%s* Question $i *\"\n# ...\n" "\n" >> "questions.rb"; done
  ```
