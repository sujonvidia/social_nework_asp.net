﻿<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;


public class Handler : IHttpHandler {
    public string exp;    
    public void ProcessRequest (HttpContext context) {
        System.Data.SqlClient.SqlDataReader rdr = null;
        System.Data.SqlClient.SqlConnection conn = null;
        System.Data.SqlClient.SqlCommand sqlcmd = null;

        try
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SecurityConnectionString"].ConnectionString;
            conn = new System.Data.SqlClient.SqlConnection(connectionString);

            sqlcmd = new System.Data.SqlClient.SqlCommand("select [RaceContent],[RaceContentType] from RacePosts where [RaceId]='" + context.Request.QueryString["raceid"] + "'", conn);
            conn.Open();
            rdr = sqlcmd.ExecuteReader();
            while (rdr.Read())
            {

                context.Response.ContentType = rdr["RaceContentType"].ToString();
                context.Response.BinaryWrite((byte[])rdr["RaceContent"]);
                
            }
            if (rdr != null)
                rdr.Close();
        }
        catch (Exception ex)
        {
            exp = ex.ToString();
        }
            
        finally
        {
            if (conn != null)
                conn.Close();
        }
    
        
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}