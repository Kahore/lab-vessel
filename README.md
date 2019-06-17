# Vessels

> Vessel monitoring solution

## Build Setup

```bash
# install dependencies
npm install

# serve with hot reload at localhost:8080
npm run dev

# build for production with minification
npm run build

# build for production and view the bundle analyzer report
npm run build --report

# run unit tests
npm run unit

# run all tests
npm test
```

For a detailed explanation on how things work, check out the [guide](http://vuejs-templates.github.io/webpack/) and [docs for vue-loader](http://vuejs.github.io/vue-loader).

> What's going on here?

This app created for internal corporative demand and achiving several goals:

- Determination of total amount of vessels distributed to locations.
- Repair and diagnostics management, aiming to prevent vessel exploding (caused by ignitions) which can damage the calorimeter and injure the lab staff.
- Prognosing needs for ordering new vessel based on linear solution (hosted as UDF and started every week).
