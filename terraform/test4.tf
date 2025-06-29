- name: Clean working directory
  run: |
    git reset --hard
    git clean -fdx

- name: Checkout repository
  uses: actions/checkout@v4
