#Ghost inject

## Installation [![npm version](https://badge.fury.io/js/ghost-inject.svg)](http://badge.fury.io/js/ghost-inject)[![Build Status](https://travis-ci.org/Gelidus/ghost-inject.svg?branch=master)](https://travis-ci.org/Gelidus/ghost-inject)
```sh
$ npm install ghost-inject
```

## Usage

**Initialization**
```javascript
injector = new Ghost();
```

**Adding services**
```javascript
anyService = {
  a: 10
};

injector.addService("any", anyService);
```

**Adding factories**
> Factories are lazy loaded services. Once the service is created by
the factory, it is saved and returned each time.

```javascript
databaseFactory = function() {
  return {
    connected: true
  };
};

injector.addFactory("database", databaseFactory);
```
