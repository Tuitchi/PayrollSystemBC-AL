report 50110 "Payroll Payslip"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = PayslipLayout;
    Caption = 'Employee Payslip';

    // Add properties to skip request page
    PreviewMode = PrintLayout;
    EnableHyperlinks = true;
    ProcessingOnly = false;

    dataset
    {
        dataitem("Payroll Entry"; "Payroll Entry")
        {
            RequestFilterFields = EntryNo, EmployeeId, PeriodStart, PeriodEnd;
            DataItemTableView = sorting(EntryNo);

            column(CompanyName; CompanyProperty.DisplayName()) { }
            column(CompanyAddress; CompanyAddr) { }
            column(ReportTitle; ReportTitle) { }

            column(EntryNo; EntryNo) { }
            column(EmployeeId; EmployeeId) { }
            column(EmployeeName; EmployeeName) { }
            column(PeriodStart; PeriodStart) { }
            column(PeriodEnd; PeriodEnd) { }
            column(PostDate; PostDate) { }

            column(GrossPay; GrossPay) { }
            // Removing fields that don't exist in the Payroll Entry table
            //column(RegularHours; RegularHours) { }
            //column(OvertimeHours; OvertimeHours) { }
            //column(OvertimeAmount; OvertimeAmount) { }

            column(SSSAmount; SSSAmount) { }
            column(PagibigAmt; PagibigAmt) { }
            column(PhilHealthAmt; PhilHealthAmt) { }
            column(TaxAmount; TaxAmount) { }
            column(OtherDed; OtherDed) { }
            column(TotalDeductions; SSSAmount + PagibigAmt + PhilHealthAmt + TaxAmount + OtherDed) { }

            column(NetPay; NetPay) { }
            column(AmountInWords; AmountInWords) { }

            trigger OnAfterGetRecord()
            var
                Employee: Record Employee;
                EmployeeData: Record "Employee Data";
                PayrollSetup: Record "Payroll Setup";
                RepCheck: Report Check;
            begin
                Clear(EmployeeName);
                Clear(CompanyAddr);
                Clear(ReportTitle);

                // Get company information
                CompanyInformation.Get();
                CompanyAddr := CompanyInformation.Address + ' ' + CompanyInformation."Address 2" + ', ' +
                               CompanyInformation.City + ', ' + CompanyInformation."Post Code";

                // Get employee information
                if EmployeeData.Get("Payroll Entry".EmployeeId) then
                    if Employee.Get(EmployeeData.EmployeeNo) then begin
                        EmployeeName := Employee."First Name" + ' ' + Employee."Last Name";

                        // Create a title that includes employee name and date for better filename when saving
                        ReportTitle := 'PAYSLIP - ' + EmployeeName + ' - ' +
                                      Format("Payroll Entry".PeriodStart, 0, '<Month,2>-<Day,2>-<Year4>') +
                                      ' to ' + Format("Payroll Entry".PeriodEnd, 0, '<Month,2>-<Day,2>-<Year4>');
                    end;

                // Convert amount to words
                Clear(AmountInWords);
                RepCheck.InitTextVariable();
                RepCheck.FormatNoText(NoText, NetPay, '');
                AmountInWords := NoText[1];
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        ShowFilter = false; // Hide filters by default

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    // Removing the ShowSignature field as it's no longer used
                    // field(ShowSignature; ShowSignature)
                    // {
                    //     ApplicationArea = All;
                    //     Caption = 'Show Signature Lines';
                    //     ToolTip = 'Specifies if signature lines should be displayed on the payslip.';
                    // }
                }
            }
        }
    }

    rendering
    {
        layout(PayslipLayout)
        {
            Type = RDLC;
            LayoutFile = './Reports/PayslipLayout.rdl';
            Caption = 'Payslip';
            Summary = 'Employee Payslip Layout';
        }
    }

    labels
    {
        PayslipLbl = 'PAYSLIP';
        EmployeeNoLbl = 'Employee ID';
        EmployeeNameLbl = 'Employee Name';
        PayPeriodLbl = 'Pay Period';
        ToLbl = 'to';
        EarningsLbl = 'EARNINGS';
        DeductionsLbl = 'DEDUCTIONS';
        GrossPayLbl = 'Gross Pay';
        RegularHoursLbl = 'Regular Hours';
        OvertimeHoursLbl = 'Overtime Hours';
        OvertimeAmountLbl = 'Overtime Amount';
        SSSLbl = 'SSS Contribution';
        PagibigLbl = 'Pag-IBIG Contribution';
        PhilHealthLbl = 'PhilHealth Contribution';
        TaxLbl = 'Withholding Tax';
        OtherDeductionsLbl = 'Other Deductions';
        TotalDeductionsLbl = 'Total Deductions';
        NetPayLbl = 'NET PAY';
        AmountInWordsLbl = 'Amount in Words';
        PreparedByLbl = 'Prepared by';
        ApprovedByLbl = 'Approved by';
        ReceivedByLbl = 'Received by';
        DateLbl = 'Date';
    }

    var
        CompanyInformation: Record "Company Information";
        CompanyAddr: Text;
        EmployeeName: Text;
        ReportTitle: Text; // Added for custom title with employee name and date
        AmountInWords: Text;
        NoText: array[2] of Text;
    // Removed ShowSignature variable as it's no longer needed
    // ShowSignature: Boolean;

    // Remove the OnInitReport trigger as it's no longer needed
    // trigger OnInitReport()
    // begin
    //     ShowSignature := true;
    // end;
}