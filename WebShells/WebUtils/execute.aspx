<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="execute.aspx.cs" Inherits="WebUtils.execute" %>


<script language="c#" runat="server">

    void Page_Load(object sender, EventArgs e)
    {
      System.Reflection.Assembly asm =  System.Reflection.Assembly.LoadFrom(@"E:\Codigo Fuente\PenTest\Intergrupo.Seguridad\bin\Intergrupo.Seguridad.Data.dll");
       Type myType = asm.GetType();
        
         System.Reflection.MethodInfo[] myArrayMethodInfo = myType.GetMethods(System.Reflection.BindingFlags.Public|System.Reflection.BindingFlags.Instance|System.Reflection.BindingFlags.DeclaredOnly);
        Console.WriteLine("\nThe number of public methods is {0}.", myArrayMethodInfo.Length);
        // Display all the methods.
        //DisplayMethodInfo(myArrayMethodInfo);
        // Get the nonpublic methods.
        System.Reflection.MethodInfo[] myArrayMethodInfo1 = myType.GetMethods(System.Reflection.BindingFlags.NonPublic|System.Reflection.BindingFlags.Instance|System.Reflection.BindingFlags.DeclaredOnly);
        //Console.WriteLine("\nThe number of protected methods is {0}.", myArrayMethodInfo1.Length);
        // Display information for all methods.
        //DisplayMethodInfo(myArrayMethodInfo1);		
    }

    </script>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
