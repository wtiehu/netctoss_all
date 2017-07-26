<%@page pageEncoding="utf-8" isELIgnored="false"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>－NetCTOSS</title>
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global.css" />
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global_color.css" />
        <script type="text/javascript" src="../js/jquery-1.11.3.js"></script>
         <script type="text/javascript" src="../js/menuDateTime.js"></script>
        <script type="text/javascript" src="../js/clearMsg.js"></script>
        <script language="javascript" type="text/javascript">
        
        	$(function(){
        		var id=$("#cost_id").val().trim();
        		$.ajax({
        			url:"findById.do",
        			type:"post",
        			dataType:"json",
        			data:{"id":id},
        			success:function(data){
        				//alert(data.name);
        				var type=data.cost_type;
        				//alert(type);
        				if(type==1){
        					document.getElementById("monthly").click();
        				}
        				if(type==2){
        					document.getElementById("package").click();
        				}
        				if(type==3){
        					document.getElementById("timeBased").click();
        				}
        			},
        			error:function(){alert("系统升级中...");}
        		});
        	});
        	
        	function update(){
        		var name = $("#name").val().trim();
				var reg_name = /^[\u4E00-\u9FA5A-Za-z0-9_]+$/;
				if (!reg_name.test(name)) {
					$("#name_msg").text("由中文,数字,字母,下划线组成").addClass("error_msg");
					return;
				}
				var duration = $("#base_duration").val().trim();
				var reg_d = /^\d{0,3}$/;
				if (!reg_d.test(duration)) {
					$("#base_duration_msg").text("0~1000之间的正整数").addClass("error_msg");
					return;
				}
				var base_cost = $("#base_cost").val().trim();
				var reg_bc = /^\d{1,3}(\.\d{1,2})?$/;
				if (!reg_bc.test(base_cost) && base_cost != "") {
					$("#base_cost_msg").text("0~999之间的整数或小数(小数保留2位)").addClass(
							"error_msg");
					return;
				}
				var unit_cost = $("#unit_cost").val().trim();
				if (!reg_bc.test(unit_cost) && unit_cost != "") {
					$("#unit_cost_msg").text("0~999之间的整数或小数(小数保留2位)").addClass(
							"error_msg");
					return;
				}
				var descr = $("#descr").val().trim();
				var reg_d = /^.{0,100}$/;
				if (!reg_d.test(descr)) {
					$("#descr_msg").text("100字符以内").addClass("error_msg");
					return;
				}
				//alert($("#costForm").serialize());
				$.ajax({
					url:"updateCost.do",
					type:"post",
					dataType:"json",
					data:$("#costForm").serialize(),
					success:function(data){
						if(data){
							location.href="findCost.do";
						}
					},
					error:function(){alert("新增功能升级中..");}
				});
        	}
        	
            //切换资费类型
            function feeTypeChange(type) {
                var inputArray = document.getElementById("main").getElementsByTagName("input");
                if (type == 1) {
                    inputArray[5].readOnly = true;
                    inputArray[5].value = "";
                    inputArray[5].className += " readonly";
                    inputArray[6].readOnly = false;
                    inputArray[6].className = "width100";
                    inputArray[7].readOnly = true;
                    inputArray[7].className += " readonly";
                    inputArray[7].value = "";
                }
                else if (type == 2) {
                    inputArray[5].readOnly = false;
                    inputArray[5].className = "width100";
                    inputArray[6].readOnly = false;
                    inputArray[6].className = "width100";
                    inputArray[7].readOnly = false;
                    inputArray[7].className = "width100";
                }
                else if (type == 3) {
                    inputArray[5].readOnly = true;
                    inputArray[5].value = "";
                    inputArray[5].className += " readonly";
                    inputArray[6].readOnly = true;
                    inputArray[6].value = "";
                    inputArray[6].className += " readonly";
                    inputArray[7].readOnly = false;
                    inputArray[7].className = "width100";
                }
            }
        </script>
    </head>
    <body>
        <!--Logo区域开始-->
        <div id="header">
           <jsp:include page="/WEB-INF/menu/logo.jsp" /> 
        </div>
        <!--Logo区域结束-->
        <!--导航区域开始-->
        <div id="navi">
           <jsp:include page="/WEB-INF/menu/menu_list.jsp" />
        </div>
        <!--导航区域结束-->
        <!--主要区域开始-->
        <div id="main">            
            <div id="save_result_info" class="save_success">保存成功！</div>
            <form id="costForm" class="main_form">
                <div class="text_info clearfix"><span>资费ID：</span></div>
                <div class="input_info"><input name="cost_id" id="cost_id" type="text" class="readonly" readonly value="${cost.cost_id }" /></div>
                <div class="text_info clearfix"><span>资费名称：</span></div>
                <div class="input_info">
                    <input id="name" onfocus="clearMsg('name_msg');" type="text" class="width300" name="name" value="${cost.name }"/>
                    <span class="required">*</span>
                    <div class="validate_msg_short" id="name_msg"></div>
                </div>
                <div class="text_info clearfix"><span>资费类型：</span></div>
                <div class="input_info fee_type">
                	
                    <input type="radio" name="cost_type" <c:if test="${cost.cost_type==1 }">checked</c:if> value="1" id="monthly" onclick="feeTypeChange(1);" />
                    <label for="monthly">包月</label>
                    <input type="radio" name="cost_type" <c:if test="${cost.cost_type==2 }">checked</c:if> value="2"  id="package" onclick="feeTypeChange(2);" />
                    <label for="package">套餐</label>
                    <input type="radio" name="cost_type"  <c:if test="${cost.cost_type==3 }">checked</c:if> value="3" id="timeBased" onclick="feeTypeChange(3);" />
                    <label for="timeBased">计时</label>
                </div>
                <div class="text_info clearfix"><span>基本时长：</span></div>
                <div class="input_info">
                    <input id="base_duration" name="base_duration" onfocus="clearMsg('base_duration_msg');" type="text" value="${cost.base_duration }" class="width100" />
                    <span class="info">小时</span>
                    <span class="required">*</span>
                    <div class="validate_msg_long" id="base_duration_msg"></div>
                </div>
                <div class="text_info clearfix"><span>基本费用：</span></div>
                <div class="input_info">
                    <input id="base_cost" name="base_cost" onfocus="clearMsg('base_cost_msg');" type="text" value="${cost.base_cost }" class="width100" />
                    <span class="info">元</span>
                    <span class="required">*</span>
                    <div class="validate_msg_long" id="base_cost_msg"></div>
                </div>
                <div class="text_info clearfix"><span>单位费用：</span></div>
                <div class="input_info">
                    <input id="unit_cost" name="unit_cost" onfocus="clearMsg('unit_cost_msg');" type="text" value="${cost.unit_cost }" class="width100" />
                    <span class="info">元/小时</span>
                    <span class="required">*</span>
                    <div class="validate_msg_long" id="unit_cost_msg"></div>
                </div>   
                <div class="text_info clearfix"><span>资费说明：</span></div>
                <div class="input_info_high">
                    <textarea id="descr" onfocus="clearMsg('descr_msg');" name="descr" class="width300 height70">${cost.descr }</textarea>
                    <div class="validate_msg_short" id="descr_msg"></div>
                </div>                    
                <div class="button_info clearfix">
                    <input type="button" value="保存" class="btn_save"  onclick="update();" />
                    <input type="button" value="取消" class="btn_save" onclick="history.back();"/>
                </div>
            </form>
        </div>
        <!--主要区域结束-->
        <div id="footer">
            <jsp:include page="/WEB-INF/menu/footer.jsp" />  
        </div>
    </body>
</html>