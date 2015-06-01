require("should")
Ghost = require("../lib/ghost")

describe "Ghost", () ->

  it "should correctly construct injector", () ->
    i = new Ghost
    i.factories.should.be.eql({})
    i.services.should.be.eql({})

  it "should add service", () ->
    i = new Ghost
    i.addService("myservice", {
      a: 5
    })

    i.services["myservice"].a.should.be.eql(5)

  it "should add factory", () ->
    i = new Ghost
    i.addFactory "myfactory", () ->
      return {
        a: 5
      }

    i.factories["myfactory"]().a.should.be.eql(5)

  it "should get service", () ->
    i = new Ghost
    i.addService("myservice", {
      a: 5
    })

    i.getService("myservice").a.should.be.eql(5)

  it "should get factorized service", () ->
    i = new Ghost
    i.addFactory "myservice", () ->
      return {
        a: 5
      }

    i.getService("myservice").a.should.be.eql(5)
    (i.services["myservice"]?).should.be.true

  it "should inject function", (done) ->
    i = new Ghost
    i.addService("myservice", {
      a: 5
    })
    i.addFactory "dataservice", () ->
      return {
        b: 10
      }

    func = (myservice, dataservice) ->
      myservice.a.should.be.eql(5)
      dataservice.b.should.be.eql(10)
      done()

    bound = i.inject(func)
    bound()

  it "should inject and call function", (done) ->
    i = new Ghost
    i.addService("myservice", {
      a: 5
    })
    i.addFactory "dataservice", () ->
      return {
        b: 10
      }

    i.call (myservice, dataservice) ->
      myservice.a.should.be.eql(5)
      dataservice.b.should.be.eql(10)
      done()

  it "should resolve function", () ->
    i = new Ghost
    i.addService("myservice", {
      a: 5
    })
    i.addFactory "dataservice", () ->
      return {
        b: 10
      }

    func = (myservice, noservice, dataservice) ->

    deps = i.resolve(func)
    deps[0].should.be.eql(i.getService("myservice"))
    (deps[1]?).should.be.false
    deps[2].should.be.eql(i.getService("dataservice"))

  it "should resolve dependencies with dependency list", () ->
    i = new Ghost

    i.addService("a", { a: 5 })
    i.addService("d", { d: true })

    func = (a, b, c, d) ->

    deps = i.resolve(func, {b: 5, c: 10})
    # existential check
    (deps[0]?).should.be.true
    (deps[1]?).should.be.true
    (deps[2]?).should.be.true
    (deps[3]?).should.be.true

    # value check
    deps[0].a.should.be.eql(5)
    deps[1].should.be.eql(5)
    deps[2].should.be.eql(10)
    deps[3].should.be.eql.true

  it "should resolve arguments of function", () ->
    i = new Ghost

    func = (a, b, c, xa, service) ->

    deps = i.getArguments(func)
    deps.length.should.be.eql(5)
    deps[0].should.be.eql("a")
    deps[3].should.be.eql("xa")
    deps[4].should.be.eql("service")

  it "should create instance of the class", (done) ->
    i = new Ghost

    i.addService("service", {
      a: 5
    })
    i.addService("db", {
      connected: true
    })

    class C
      constructor: (service, db, maybenull) ->
        service.a.should.be.eql(5)
        db.connected.should.be.true
        (maybenull?).should.be.false
        done()

    i.create(C)
