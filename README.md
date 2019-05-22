# PrintNode Business Central Integration

This is a fully AL based integration with the provider PrintNode.
The purpose of this is to have **direct printing** _(report.run(id,FALSE,FALSE) like)_ in Business Central SaaS installations.

In order to begin, go through the following steps:

1. Create an account in http://printnode.com and select a plan (you get 30 days trial). Install the printnode app on the computer you wish to print through and enable at least one printer.
2. Generate an APIKey for Business Central https://app.printnode.com/apikeys
3. Install the extension in the customer BC SaaS or OnPremise installation
4. Go to the newly installed extension and allow the HTTPClient calls in the extension card page.
5. Go to the "PrintNode Setup" page (you can search it in BC) and input the e-mail account, the APIKey generated previously
6. In the "PrintNode Setup" window, click on the "Get PrintNode Printers". If all goes well, you can check the printers in the "PrintNode Printers" window.
7. In the "PrintNode Setup" window, set a default printer in the "Default Printer ID".
8. In the "PrinterNode Printer Selection" set up the printers you wish to use for each report and UserID (just like the standard Printer Selection window).

As far as the set up goes, you're done. All you have to do now is set up your extension to access this one and take advantage of it, or include the objects of this extension in your own extensions.

In order to create the dependency, in your app.json, add the dependencies to this extension. For more information on how to do that, check this link: https://www.hougaard.com/how-to-reference-another-extension-from-an-extension/

Once you're done, just declare a variable in your code, Codeunit: "PrintNode Management", and call the **SendReportToPrintNode(ReportID: Integer; RecVariant: Variant; PrintJobTitle: Text)** function and call it whenever necessary.

If you have any doubts or comments, you can find me on http://twitter.com/jcastrofer
