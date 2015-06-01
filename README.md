#Ghost inject [![npm version](https://badge.fury.io/js/ghost-inject.svg)](http://badge.fury.io/js/ghost-inject)[![Build Status](https://travis-ci.org/Gelidus/ghost-inject.svg?branch=master)](https://travis-ci.org/Gelidus/ghost-inject)

Ghost is simple dependency injection manager. It is easy to use and avaliable in node.js and browser. No dependencies are needed.

## Installation
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

**Calling functions with dependencies**
```javascript
func = function(database) {
  // database is injected here if service or factory was provided before
};

injector.call(func)
```

**Injecting functions**
```javascript
func = function(database) {
  // database is injected here if service or factory was provided before
};

// injector will return function with bound arguments
bound = injector.inject(func);
bound(); // call injected function
```

> both `call` and `inject` can be provided with **this** parameter as a second parameter. Also additional dependency list can be provided for local dependencies.

> if **collision** occurs within specified list and service in the injector, service from the list will be used

**Creating instances**
```javascript
car = function(people) {
  this.people = people;
  this.handbreak = true;
};

myCar = injector.create(car);
```

> `people` argument will here be injected into constructor if service called `people` was previously defined

**Resolving dependencies**
```javascript
func = function(firstdep, seconddep) {};

deps = injector.resolve(func);
// deps is now array containing arguments for the given function
```

**Getting function arguments**
```javascript
func = function(a, b, c) {};

deps = injector.getArguments(func)
// deps = ['a', 'b', 'c']
```
