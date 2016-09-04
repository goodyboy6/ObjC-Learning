/**
 * Created by yixiaoluo on 2016/8/30.
 */

//第一步把之前的数据写成一个数组的形式,定义变量为 infos
var infos = [
    ['小A','女',21,'大一'],  ['小B','男',23,'大三'],
    ['小C','男',24,'大四'],  ['小D','女',21,'大一'],
    ['小E','女',22,'大四'],  ['小F','男',21,'大一'],
    ['小G','女',22,'大二'],  ['小H','女',20,'大三'],
    ['小I','女',20,'大一'],  ['小J','男',20,'大三']
];

//第一次筛选，找出都是大一的信息
var ones = new Array();
infos.forEach(function(info, idx1, arr2){
    info.forEach(function(ttt, idx2, arr2){
        if (ttt === '大一'){
           ones.push(info);
        }
    })
})
console.log(ones);

//第二次筛选，找出都是女生的信息

