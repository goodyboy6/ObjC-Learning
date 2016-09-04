/**
 * Created by yixiaoluo on 2016/8/30.
 */

//创建数组
var array = new Array();
array.push(1);
Array.prototype.push.apply(array, [1, 2, 3, 4, 5]);

//显示数组长度
window.document.write(array.length);

//将数组内容输出，完成达到的效果。
array.forEach(function(item, idx, arr){
    window.document.write(item + '<br/>');
})