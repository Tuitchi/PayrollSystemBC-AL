page 50102 "Payroll Entry List"
{
    ApplicationArea = All;
    Caption = 'Payroll Entries';
    PageType = List;
    SourceTable = "Payroll Entry";
    UsageCategory = Lists;
    Editable = false;
    CardPageId = 50103; // "Payroll Entry Card"

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(EntryNo; Rec.EntryNo)
                {
                    ToolTip = 'Specifies the entry number of the payroll entry.';
                }
                field(EmployeeId; Rec.EmployeeId)
                {
                    ToolTip = 'Specifies the employee number for this payroll entry.';
                    TableRelation = "Employee Data".EmployeeId;
                    LookupPageId = "Employee Rate List";
                }
                field(FirstName; FirstName)
                {
                    Caption = 'First Name';
                    ToolTip = 'Specifies the first name of the employee.';
                    Editable = false;
                }
                field(LastName; LastName)
                {
                    Caption = 'Last Name';
                    ToolTip = 'Specifies the last name of the employee.';
                    Editable = false;
                }
                field(PeriodStart; Rec.PeriodStart)
                {
                    ToolTip = 'Specifies the start date of the payroll period.';
                }
                field(PeriodEnd; Rec.PeriodEnd)
                {
                    ToolTip = 'Specifies the end date of the payroll period.';
                }
                field(PostDate; Rec.PostDate)
                {
                    ToolTip = 'Specifies the posting date of the payroll entry.';
                }
                field(GrossPay; GrossPay)
                {
                    Caption = 'Gross Pay';
                    Editable = false;
                }
                field(SSSAmount; Rec.SSSAmount)
                {
                    Caption = 'SSS';
                    ToolTip = 'SSS contribution calculated using rate from PH Payroll Setup';
                    Editable = false;
                }
                field(PagibigAmt; Rec.PagibigAmt)
                {
                    Caption = 'Pag-IBIG';
                    ToolTip = 'Pag-IBIG contribution calculated using rate from PH Payroll Setup';
                    Editable = false;
                }
                field(PhilHealthAmt; Rec.PhilHealthAmt)
                {
                    Caption = 'PhilHealth';
                    ToolTip = 'PhilHealth contribution calculated using rate from PH Payroll Setup';
                    Editable = false;
                }
                field(TaxAmount; Rec.TaxAmount)
                {
                    Caption = 'Tax';
                    ToolTip = 'Withholding tax amount';
                    Editable = false;
                }
                field(NetPay; Rec.NetPay)
                {
                    ToolTip = 'Specifies the net pay amount for this payroll entry.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status of the payroll entry.';
                }
            }

            group(Summary)
            {
                Caption = 'Summary';

                field(TotalGrossPay; TotalGrossPay)
                {
                    Caption = 'Total Gross Pay';
                    Editable = false;
                }

                field(TotalSSSAmount; TotalSSSAmount)
                {
                    Caption = 'Total SSS Contributions';
                    Editable = false;
                }

                field(TotalPagIBIGAmount; TotalPagIBIGAmount)
                {
                    Caption = 'Total Pag-IBIG Contributions';
                    Editable = false;
                }

                field(TotalPhilHealthAmount; TotalPhilHealthAmount)
                {
                    Caption = 'Total PhilHealth Contributions';
                    Editable = false;
                }

                field(TotalTaxAmount; TotalTaxAmount)
                {
                    Caption = 'Total Tax';
                    Editable = false;
                }

                field(TotalOtherDeductions; TotalOtherDeductions)
                {
                    Caption = 'Total Other Deductions';
                    Editable = false;
                }

                field(TotalDeductions; TotalDeductions)
                {
                    Caption = 'Total All Deductions';
                    Editable = false;
                    Style = Attention;
                }

                field(TotalPayrollEntries; TotalPayrollEntries)
                {
                    Caption = 'Total Payroll Entries';
                    Editable = false;
                }
                field(TotalNetPay; TotalNetPay)
                {
                    Caption = 'Total Net Pay';
                    Editable = false;
                    Style = Strong;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("RefreshSummary")
            {
                ApplicationArea = All;
                Caption = 'Refresh Summary';
                Image = Refresh;
                ToolTip = 'Refresh the summary data to reflect current selection.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CalculateTotals();
                    CurrPage.Update(false);
                    Message('Summary data has been refreshed.');
                end;
            }

            action("Calculate")
            {
                ApplicationArea = All;
                Caption = 'Calculate';
                Image = Calculate;
                ToolTip = 'Recalculate the payroll entry based on the current setup.';

                trigger OnAction()
                var
                    PayrollEntry: Record "Payroll Entry";
                begin
                    PayrollEntry.Get(Rec.EntryNo);
                    PayrollEntry.Validate(GrossPay, Rec.GrossPay);
                    PayrollEntry.Modify(true);
                    CurrPage.Update(false);
                end;
            }

            action("Release")
            {
                ApplicationArea = All;
                Caption = 'Release';
                Image = ReleaseDoc;
                ToolTip = 'Change the status of the payroll entry to Released.';
                Enabled = (Rec.Status = Rec.Status::Draft);

                trigger OnAction()
                var
                    PayrollEntry: Record "Payroll Entry";
                begin
                    if Rec.Status = Rec.Status::Draft then begin
                        PayrollEntry.Get(Rec.EntryNo);
                        PayrollEntry.Status := PayrollEntry.Status::Released;
                        PayrollEntry.Modify(true);
                        CurrPage.Update(false);
                    end;
                end;
            }

            action("Reopen")
            {
                ApplicationArea = All;
                Caption = 'Reopen';
                Image = ReOpen;
                ToolTip = 'Change the status of the payroll entry back to Draft.';
                Enabled = (Rec.Status = Rec.Status::Released);

                trigger OnAction()
                var
                    PayrollEntry: Record "Payroll Entry";
                begin
                    if Rec.Status = Rec.Status::Released then begin
                        PayrollEntry.Get(Rec.EntryNo);
                        PayrollEntry.Status := PayrollEntry.Status::Draft;
                        PayrollEntry.Modify(true);
                        CurrPage.Update(false);
                    end;
                end;
            }

            action("Print Payslip")
            {
                ApplicationArea = All;
                Caption = 'Print Payslip';
                Image = PrintReport;
                ToolTip = 'Generate and print a payslip for the selected employee.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = (Rec.Status = Rec.Status::Released);

                trigger OnAction()
                begin
                    GeneratePayslip();
                end;
            }
        }


    }
    var
        FirstName: Text[50];
        LastName: Text[50];
        EmployeeRec: Record Employee;
        GrossPay: Decimal;
        EmployeeRateRec: Record "Employee Data";
        TotalNetPay: Decimal;
        TotalSSSAmount: Decimal;
        TotalGrossPay: Decimal;
        TotalPagIBIGAmount: Decimal;
        TotalPhilHealthAmount: Decimal;
        TotalTaxAmount: Decimal;
        TotalOtherDeductions: Decimal;
        TotalDeductions: Decimal;
        TotalPayrollEntries: Integer;

    trigger OnAfterGetRecord()
    begin
        Clear(FirstName);
        Clear(LastName);
        Clear(GrossPay);
        if EmployeeRateRec.Get(Rec.EmployeeId) then begin
            GrossPay := EmployeeRateRec.Rate;

            // Use EmployeeNo to fetch from standard Employee table
            if EmployeeRec.Get(EmployeeRateRec.EmployeeNo) then begin
                FirstName := EmployeeRec."First Name";
                LastName := EmployeeRec."Last Name";
            end;
        end;

        // Update summary when moving to a new record
        CalculateTotals();
        CurrPage.Update(false);
    end;

    trigger OnOpenPage()
    begin
        CalculateTotals();
        CurrPage.Update(false);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalculateTotals();
        CurrPage.Update(false);
    end;

    local procedure CalculateTotals()
    var
        PayrollEntry: Record "Payroll Entry";
        CurrentRecordIncluded: Boolean;
        CurrentRecordNetPay: Decimal;
    begin
        Clear(TotalNetPay);
        Clear(TotalSSSAmount);
        Clear(TotalGrossPay);
        Clear(TotalPagIBIGAmount);
        Clear(TotalPhilHealthAmount);
        Clear(TotalTaxAmount);
        Clear(TotalOtherDeductions);
        Clear(TotalDeductions);
        Clear(TotalPayrollEntries);
        CurrentRecordIncluded := false;
        CurrentRecordNetPay := 0;

        PayrollEntry.Reset();
        // Apply the same filters as the page to only sum visible entries
        PayrollEntry.CopyFilters(Rec);

        if PayrollEntry.FindSet() then
            repeat
                // Check if this is the currently selected record
                if PayrollEntry.EntryNo = Rec.EntryNo then begin
                    CurrentRecordIncluded := true;
                    CurrentRecordNetPay := PayrollEntry.NetPay;
                end;

                TotalNetPay += PayrollEntry.NetPay;
                TotalGrossPay += PayrollEntry.GrossPay;
                TotalSSSAmount += PayrollEntry.SSSAmount;
                TotalPagIBIGAmount += PayrollEntry.PagibigAmt;
                TotalPhilHealthAmount += PayrollEntry.PhilHealthAmt;
                TotalTaxAmount += PayrollEntry.TaxAmount;
                TotalOtherDeductions += PayrollEntry.OtherDed;
                TotalPayrollEntries += 1;
            until PayrollEntry.Next() = 0;

        TotalDeductions := TotalSSSAmount + TotalPagIBIGAmount + TotalPhilHealthAmount + TotalTaxAmount + TotalOtherDeductions;

        // Store information about current record for display purposes
        if CurrentRecordIncluded and (TotalPayrollEntries > 1) then begin
            // Information is stored in variables but we can't update the caption directly
            // This information can be displayed in other ways if needed
        end;
    end;

    local procedure GeneratePayslip()
    var
        PayrollEntry: Record "Payroll Entry";
        EmployeeRec: Record Employee;
        EmployeeRateRec: Record "Employee Data";
        ReportParameters: Text;
    begin
        // Get the current record
        PayrollEntry.Get(Rec.EntryNo);

        // Check if the payroll entry status is Released
        if PayrollEntry.Status <> PayrollEntry.Status::Released then begin
            Error('Payslip can only be printed when the status is Released.');
            exit;
        end;

        // Check if employee exists
        if not EmployeeRateRec.Get(PayrollEntry.EmployeeId) then begin
            Error('Employee data not found.');
            exit;
        end;

        // Get employee information
        if not EmployeeRec.Get(EmployeeRateRec.EmployeeNo) then begin
            Error('Employee record not found.');
            exit;
        end;

        if Confirm(StrSubstNo('Do you want to print the payslip for %1 %2?', EmployeeRec."First Name", EmployeeRec."Last Name")) then begin
            // Set filter for the selected entry and run the report
            PayrollEntry.SetRange(EntryNo, PayrollEntry.EntryNo);

            // Run the report using the regular RunModal
            Report.RunModal(50110, false, false, PayrollEntry);

            Message('Payslip generated for %1 %2', EmployeeRec."First Name", EmployeeRec."Last Name");
        end;
    end;
}