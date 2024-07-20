{
  hooks = [
    {
      name = "eslint";
      run-on = "pre-push";
      command = "npx eslint --max-warnings=0 {staged_files}";
    }
    {
      name = "lint";
      run-on = "pre-push";
      command = "npm run lint {staged_files}";
    }
    {
      name = "prettier";
      run-on = "pre-push";
      command = "npx prettier -c {staged_files}";
    }
  ];
}
