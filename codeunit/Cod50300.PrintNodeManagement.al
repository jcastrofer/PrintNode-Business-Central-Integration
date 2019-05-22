codeunit 50300 "Print Node Management"
{
    procedure SendReportToPrintNode(ReportID: Integer; RecVariant: Variant; PrintJobTitle: text)
    var
        RecRef: RecordRef;
        DataTypeMgt: Codeunit "Data Type Management";
        PrintNodePrinters: Record "PrintNode Printer";
        PrintNodePrinterSelection: Record "PrintNode Printer Selection";
        TempBlob: Record TempBlob temporary;
        OStream: OutStream;
        Parameters: Text;
        OrderConfirmation: Report "Order Confirmation";
    begin
        if not RecVariant.IsRecord then
            exit;
        if ReportID = 0 then
            exit;

        clear(RecRef);
        ClearLastError();
        clear(TempBlob);
        clear(OStream);

        PrintNodePrinterSelection.Reset();
        PrintNodePrinterSelection.setrange("Report ID", ReportID);
        PrintNodePrinterSelection.setrange("User ID", UserId);
        if not PrintNodePrinterSelection.findset then begin
            PrintNodePrinterSelection.setrange("User ID", '');
            if not PrintNodePrinterSelection.findset then
                exit;
        end;
        PrintNodePrinterSelection.testfield("Printer ID");

        PrintNodePrinters.Reset();
        PrintNodePrinters.get(PrintNodePrinterSelection."Printer ID");

        if not DataTypeMgt.GetRecordRef(RecVariant, RecRef) then
            error('An unexpected error ocurred: ' + GetLastErrorText);

        clear(TempBlob);
        TempBlob.Blob.CreateOutStream(OStream);
        if not Report.SaveAs(ReportID, '', ReportFormat::Pdf, OStream, RecRef) then
            error('The PDF file could not be generated: ' + GetLastErrorText);

        NewPrintJob(TempBlob, PrintNodePrinterSelection, PrintJobTitle);
    end;

    local procedure NewPrintJob(TempBlob: Record TempBlob; PrintNodePrinterSelection: Record "PrintNode Printer Selection"; PrintJobTitle: text)
    var
        Client: HttpClient;
        Content: HttpContent;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        PrintNodeSetup: Record "PrintNode Setup";
        PrintNodePrinter: Record "PrintNode Printer";
        ErrConn: Label 'An error ocurred connecting to PrintNode';
        URI: Text;
        ContentTxt: Text;
        jObject: JsonObject;
    begin
        clear(jObject);
        clear(ContentTxt);

        PrintNodeSetup.Reset();
        PrintNodeSetup.Get();
        if not PrintNodeSetup."Enable PrintNode Integration" then
            exit;

        if PrintNodePrinterSelection."Printer ID" = '' then
            exit;

        PrintNodePrinter.Reset();
        PrintNodePrinter.get(PrintNodePrinterSelection."Printer ID");

        PrintNodeSetup.testfield("PrintNode Base Endpoint");
        PrintNodeSetup.testfield("PrintNode PrintJob Resource");

        URI := PrintNodeSetup."PrintNode Base Endpoint" + PrintNodeSetup."PrintNode PrintJob Resource";
        client.DefaultRequestHeaders.Add('Authorization', 'Basic ' + GetAPIKeyBase64());
        Client.DefaultRequestHeaders.Add('X-Pretty', '');

        jObject.Add('printerId', PrintNodePrinter."Printer ID");
        jObject.Add('title', PrintJobTitle);
        jObject.Add('contentType', 'pdf_base64');
        jObject.Add('content', TempBlob.ToBase64String());
        jObject.Add('source', 'Business Central PrintNode Integration');
        jObject.WriteTo(ContentTxt);

        content.WriteFrom(ContentTxt);

        if not client.Post(URI, Content, ResponseMessage) then
            error(ErrConn);
        if not ResponseMessage.IsSuccessStatusCode then
            Error(ResponseMessage.ReasonPhrase);
    end;

    procedure GetPrinters()
    var
        Client: HttpClient;
        Content: HttpContent;
        //Headers: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        PrintNodeSetup: Record "PrintNode Setup";
        ErrConn: Label 'An error ocurred connecting to PrintNode';
        URI: Text;
        ContentTxt: Text;
        jToken: JsonToken;
        jToken2: JsonToken;
    begin
        PrintNodeSetup.Reset();
        PrintNodeSetup.Get();
        if not PrintNodeSetup."Enable PrintNode Integration" then
            exit;

        PrintNodeSetup.testfield("PrintNode Base Endpoint");
        PrintNodeSetup.testfield("PrintNode Printers Resource");

        URI := PrintNodeSetup."PrintNode Base Endpoint" + PrintNodeSetup."PrintNode Printers Resource";
        client.DefaultRequestHeaders.Add('Authorization', 'Basic ' + GetAPIKeyBase64());
        Client.DefaultRequestHeaders.Add('X-Pretty', '');
        client.Get(URI, ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode then
            Error(ErrConn);
        Content := ResponseMessage.Content;

        Content.ReadAs(ContentTxt);
        jToken.ReadFrom(ContentTxt);
        //jToken.SelectToken(,jToken2); //TODO pendiente de terminar la importación de info impresoras
        //message(ContentTxt);
    end;

    local procedure GetAPIKey(): Text
    var
        PrintNodeSetup: Record "PrintNode Setup";
    begin
        PrintNodeSetup.Reset();
        PrintNodeSetup.get();
        PrintNodeSetup.testfield("PrintNode API Key");
        exit(PrintNodeSetup."PrintNode API Key");
    end;

    local procedure GetAPIKeyBase64(): Text
    var
        Base64Convert: Codeunit Base64Convert;
    begin
        exit(Base64Convert.TextToBase64String(GetAPIKey));
    end;
}