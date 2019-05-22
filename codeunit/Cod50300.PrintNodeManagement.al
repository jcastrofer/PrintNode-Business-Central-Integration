codeunit 50300 "Print Node Management"
{
    procedure SendReportToPrintNode(ReportID: Integer; RecVariant: Variant; PrintJobTitle: text)
    var
        RecRef: RecordRef;
        DataTypeMgt: Codeunit "Data Type Management";
        PrintNodePrinters: Record "PrintNode Printer";
        PrintNodePrinterSelection: Record "PrintNode Printer Selection";
        PrintNodeSetup: Record "PrintNode Setup";
        TempBlob: Record TempBlob temporary;
        OStream: OutStream;
        PrinterID: Code[20];
    begin
        if not RecVariant.IsRecord then
            exit;
        if ReportID = 0 then
            exit;

        PrintNodeSetup.Reset();
        if not PrintNodeSetup.Get() then
            PrintNodeSetup.InsertIfNotExists();
        if not PrintNodeSetup."Enable PrintNode Integration" then
            exit;
        PrintNodeSetup.TestField("Default Printer ID");

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
                PrinterID := PrintNodeSetup."Default Printer ID"
            else
                PrinterID := PrintNodePrinterSelection."Printer ID";
        end else
            PrinterID := PrintNodePrinterSelection."Printer ID";
        if PrinterID = '' then
            error('Printer configuration is missing for ReportID ' + format(ReportID));

        PrintNodePrinters.Reset();
        PrintNodePrinters.get(PrinterID);

        if not DataTypeMgt.GetRecordRef(RecVariant, RecRef) then
            error('An unexpected error ocurred: ' + GetLastErrorText);

        clear(TempBlob);
        TempBlob.Blob.CreateOutStream(OStream);
        if not Report.SaveAs(ReportID, '', ReportFormat::Pdf, OStream, RecRef) then
            error('The PDF file could not be generated: ' + GetLastErrorText);

        NewPrintJob(TempBlob, PrinterID, PrintJobTitle);
    end;

    local procedure NewPrintJob(TempBlob: Record TempBlob; PrinterID: Code[20]; PrintJobTitle: text)
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

        if PrinterID = '' then
            exit;

        PrintNodePrinter.Reset();
        PrintNodePrinter.get(PrinterID);

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
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        PrintNodeSetup: Record "PrintNode Setup";
        PrintNodePrinter: Record "PrintNode Printer";
        ErrConn: Label 'An error ocurred connecting to PrintNode';
        URI: Text;
        ContentTxt: Text;
        jToken: JsonToken;
        jToken2: JsonToken;
        jArray: JsonArray;
        jObject: JsonObject;
        i: Integer;
        Stop: Boolean;
        IDTxt: Text;
        DescriptionTxt: Text;
        stateTxt: Text;
    begin
        if not Confirm('Do you wish to retrieve all the printers in your account?') then
            exit;
        PrintNodeSetup.Reset();
        PrintNodeSetup.Get();
        if not PrintNodeSetup."Enable PrintNode Integration" then
            exit;

        PrintNodeSetup.testfield("PrintNode Base Endpoint");
        PrintNodeSetup.testfield("PrintNode Printers Resource");

        PrintNodePrinter.Reset();
        PrintNodePrinter.DeleteAll();

        URI := PrintNodeSetup."PrintNode Base Endpoint" + PrintNodeSetup."PrintNode Printers Resource";
        client.DefaultRequestHeaders.Add('Authorization', 'Basic ' + GetAPIKeyBase64());
        Client.DefaultRequestHeaders.Add('X-Pretty', '');
        client.Get(URI, ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode then
            Error(ErrConn);
        Content := ResponseMessage.Content;

        Content.ReadAs(ContentTxt);

        jArray.ReadFrom(ContentTxt);
        Stop := false;
        while not Stop do begin
            if not jArray.Get(i, jToken) then
                Stop := true;
            jObject := jToken.AsObject();

            jObject.Get('description', jToken2);
            jToken2.WriteTo(DescriptionTxt);
            DescriptionTxt := DelChr(DescriptionTxt, '=', '"');

            jObject.Get('id', jToken2);
            jToken2.WriteTo(IDTxt);

            jObject.Get('state', jToken2);
            jToken2.WriteTo(stateTxt);
            stateTxt := DelChr(stateTxt, '=', '"');

            if (IDTxt <> '') and (DescriptionTxt <> '') then begin
                PrintNodePrinter.Init();
                PrintNodePrinter."Printer ID" := IDTxt;
                PrintNodePrinter."Printer Name" := Copystr(DescriptionTxt, 1, MaxStrLen(PrintNodePrinter."Printer Name"));
                PrintNodePrinter.State := stateTxt;
                if PrintNodePrinter.Insert() then;
            end;

            i += 1;
        end;
        Message('Process finished');


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