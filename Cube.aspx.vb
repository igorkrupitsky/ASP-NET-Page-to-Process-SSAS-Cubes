Public Class Cube
    Inherits System.Web.UI.Page

    Public sServer As String = "Server1"
    Public sDatabase As String = "Db1"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Request.QueryString("process") = "1" Then
		Page.Server.ScriptTimeout = 60*20 ' 20 mins

            Try
                ProcessSsas()
                Response.Write("1")
            Catch ex As Exception
                Response.Write(ex.Message)
            End Try
            Response.End()
        End If

    End Sub

    Private Sub ProcessSsas()
        Dim oServer As New Microsoft.AnalysisServices.Server()
        oServer.Connect(GetConnectionString())
        Dim oDatabase As Microsoft.AnalysisServices.Database = oServer.Databases.FindByName(sDatabase)
        oDatabase.Process(Microsoft.AnalysisServices.ProcessType.ProcessFull)
    End Sub

    Private Function GetConnectionString() As String
        Return "Provider=MSOLAP.6;Initial Catalog=" & sDatabase & ";Data Source=" & sServer
    End Function

    Public Sub GetCubeList()
        Dim cn As New Microsoft.AnalysisServices.AdomdClient.AdomdConnection(GetConnectionString())
        cn.Open()

        If cn.Cubes.Count = 0 Then
            Response.Write("<tr><td colspan=2>No Cubes</td></tr>" & vbCrLf)
        End If

        For i = 0 To cn.Cubes.Count - 1
            If cn.Cubes(i).Name.Substring(0, 1) <> "$" Then
                Response.Write("<tr><td>")
                Response.Write(cn.Cubes(i).Name)
                Response.Write("</td><td>")
                Response.Write(cn.Cubes(i).LastProcessed)
                Response.Write("</td></tr>" & vbCrLf)
            End If
        Next

        cn.Close()
    End Sub

End Class