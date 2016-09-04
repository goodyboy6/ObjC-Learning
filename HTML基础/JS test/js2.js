/**
 * Created by yixiaoluo on 2016/8/30.
 */

//通过javascript的日期对象来得到当前的日期，并输出。
var date = new Date();
var year = date.getFullYear();
var month = date.getMonth() + 1;
var day = date.getDate();

var weekdays = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"];
var weekday = date.getDay();
console.log(year + "-" + month + "-" + day + " " + weekdays[weekday]);


//成绩是一长窜的字符串不好处理，找规律后分割放到数组里更好操作哦
var scoreStr = "小明:87;小花:81;小红:97;小天:76;小张:74;小小:94;小西:90;小伍:76;小迪:64;小曼:76";
var scoreArray = scoreStr.split(";");
console.log(scoreArray);


//从数组中将成绩撮出来，然后求和取整，并输出
var sum = scoreArray.reduce(function(x, y){
    var value = parseInt(y.split(":")[1]);
    return x + value;
}, 0)
console.log(sum) ;