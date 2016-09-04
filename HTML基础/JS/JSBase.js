/**
 * Created by yixiaoluo on 2016/8/25.
 */

/*
//=====================Array==========================
var arr = [1,2,3];
arr.forEach(function(item, index, a){
    console.log(item + "|" + index + "|" + a);
})

var sum = arr.reduce(function(x, y, a){
    return x+y;
})
var max = arr.reduce(function(x, y,a){
    return x>y ? x : y;
})
console.log(sum + '|' + max);

var mm = arr.map(function(item, idex, a){
    return item * 10;
})
console.log(mm);

var slice = arr.slice(0,2);
console.log(slice);

var str = "helllo world";
//获取join方法，调用call调用
console.log(Array.prototype.join.call(str, "_") + '|' + str.length);

//=====================字面量对象==========================
var a = {
    prop: 33,
    f: function(){
    return this.prop;
}
}
console.log(a.f());
//等驾驭==============>
var a1 = {prop: 33};
function f1(){
    return this.prop;
}
console.log(f1());
a1.f1 = f1;
console.log(a1.f1() + '|' + a1.hasOwnProperty('f1'));


//=====================call/apply与this==========================
function add(c, d){
    return this.a + this.b + c +d;
}
var o = {a:3, b:5};
//以下等价
var result = add.call(o, 10, 20);
var result2 = add.apply(o, [10, 20]);
console.log(result + '|' + result2);
//解决的问题：调用一些没法直接调用的方法
console.log(Object.prototype.toString.call(7));

console.log(add(1));

//=====================bind与currying：函数拆分==========================
function getConfig(colors, size, otherOptions){
    console.log(colors, size, otherOptions);
}
var defaultConfig = getConfig.bind(null, "#CC0000", '1024*768');
defaultConfig('123');//#CC0000 1024*768 123
defaultConfig('456');//#CC0000 1024*768 456

//=====================作用域:ES3执行上下文==========================
console.log(x);//[Function: x]

var x = 5;
console.log(x);//5

function x(){};

//=====================作用域:ES3执行上下文==========================
function Foo(){
    this.x = 1111;
}

var foo1 = new Foo();
console.log(foo1.x, x);

*/

//=====================OOP==========================
//http://www.zhihu.com/question/20289071
function Animal(name){
    this.name = name;
}

function Person(age, name){
    Animal.call(this, name);//继承animal
    this.age = age;
}

Animal.prototype.hi = function(text){
    console.log( this.name/* */+ " says: " + text);
}
//Person.prototype = Object.create(Animal.prototype);//创建一个空对象，proto指向Animal.prototype //====>等价于 Person.prototype = new Animal();
//Person.prototype.constructor = Person;//更改构造器
//Person.prototype.hi = function(text){
//    console.log( this.name + " is " + this.age + " years old, " + "he says: " + text);
//}
var person = new Person(12, "Kiy");
//person.hi("yyyyyyyyyyyyy");


//=====================>以下等价:anObj原型继承自Animal
var anObj = {"name": "Kitty"};
Animal.prototype.hi.call(anObj, "ttttttttt");
Animal.prototype.hi.apply(anObj, ["ttttttttt"]);
Animal.prototype.hi.bind(anObj, "ttttttttt")();//bind不会自动调用

console.log([1, 2] instanceof Object);