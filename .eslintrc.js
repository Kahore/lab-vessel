// https://eslint.org/docs/user-guide/configuring

module.exports = {
  root: true,
  parserOptions: {
    parser: 'babel-eslint',
  },
  env: {
    browser: true,
  },
  extends: [
    // https://github.com/vuejs/eslint-plugin-vue#priority-a-essential-error-prevention
    // consider switching to `plugin:vue/strongly-recommended` or `plugin:vue/recommended` for stricter rules.
    'plugin:vue/essential',
    // https://github.com/standard/standard/blob/master/docs/RULES-en.md
    //'standard',
    //'prettier',
    'prettier/standard',
    'prettier/vue',
  ],
  // required to lint *.vue files
  plugins: ['prettier', 'vue'],
  //plugins: ['vue'],
  // add your custom rules here
  rules: {
    semi: ['error', 'always'],
    quotes: ['error', 'single'],
    // allow async-await
    'generator-star-spacing': 'off',
    // allow debugger during development
    'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'off',
    'space-before-function-paren': 'always',
    // 'prettier/prettier': [
    //   'error',
    //   {},
    //   {
    //     usePrettierrc: false,
    //   },
    // ],
    'prettier/prettier': ['error', { singleQuote: true, parser: 'flow', spaceBeforeFunctionParen: true }],
  },
};
