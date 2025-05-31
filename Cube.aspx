<%@ Page Language="vb" CodeFile="Cube.aspx.vb" Inherits="Cube" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Cubes</title>

    <script src="Content/jquery-1.10.2.min.js"></script>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />

    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta charset="utf-8"> 
    <script>
	var start = null;
	var iTimeToProcess = 60*4; //4 mins

	function Process() {
            $("#idResult").show();
            $(".progress").show();

		if (start==null){
			start = new Date;

			setInterval(function() {
				var iSec = (new Date - start) / 1000;
				var iPct = parseInt(100 * iSec / iTimeToProcess) + "%";
   				$('.progress-bar').width(iPct).text(iPct);
			}, 1000);
		}

            $.get("?process=1",{ "_": $.now() }, function (data) {
                $(".progress").hide();

                if (data == "1") {
                    location = "?refresh=1";
                }else{
                    $("#txtResult").show().val(data);
                }
            })
        }
    </script>    
</head>
<body>
    <form id="form1" runat="server">
    <div class="container">
       <H1>Cubes for <%=sServer%> - <%=sDatabase%></H1>

        <table class="table table-striped table-hover">
               <tr>
                   <th>Cube</th>
                   <th>Last Processed</th>
               </tr>
            <%GetCubeList()%>
        </table>

        <div class="form-group">
            <button class="btn btn-default" onclick="Process(); return false;">Process Cubes</button>
        </div>

	<div id="idResult" class="form-group" style="display: none;">
		<textarea id="txtResult" class="form-control" rows="8" style="display: none;"></textarea>
	    
		<div class="progress">
			<div class="progress-bar" role="progressbar" aria-valuenow="70" aria-valuemin="0" aria-valuemax="100" style="width:0%"></div>
		</div>
	</div>       

    </div>

    </form>
</body>
</html>
