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

- Understanding total vessel quantites distribute by location
- Manage the repair and diagnostical procedere, cause after some fired (different for each vessel type) calorimetrical vessel can be blow up and get gamage for calorimeter and lab staff
- Prognosing needs for ordering new vessel base on linear estimates solution(hosted as UDF and started every week)
- Builds a graph with pre-lim and limit by individual or type vessel
