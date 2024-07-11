{
  hooks = [
    {
      name = "eslint";
      run-on = "pre-commit";
      command = "npx eslint --max-warnings=0 {staged_files}";
    }
    {
      name = "lint";
      run-on = "pre-commit";
      command = "npm run lint {staged_files}";
    }
    {
      name = "build";
      run-on = "pre-push";
      command = "npm run build";
    }
  ];
}
