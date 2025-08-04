page 50116 "Payroll Transaction Card"
{
    PageType = Card;
    SourceTable = "Payroll Transaction";
    Caption = 'Payroll Transaction Card';
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General Information';
                field("Payroll Period ID"; Rec."Payroll Period ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payroll period ID.';
                    Importance = Promoted;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee number.';
                    Importance = Promoted;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee name.';
                    Importance = Promoted;
                    Editable = false;
                }
                field("Department ID"; Rec."Department ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department ID.';
                    Importance = Promoted;
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the transaction.';
                    Importance = Promoted;
                }
            }

            group(Payroll)
            {
                Caption = 'Payroll Information';
                field("Gross Pay"; Rec."Gross Pay")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the gross pay.';
                    Importance = Promoted;
                }
                field("Net Pay"; Rec."Net Pay")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the net pay.';
                    Importance = Promoted;
                }
            }

            group(Contributions)
            {
                Caption = 'Contributions and Deductions';
                field("SSS Contribution"; Rec."SSS Contribution")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SSS contribution.';
                }
                field("PhilHealth Contribution"; Rec."PhilHealth Contribution")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the PhilHealth contribution.';
                }
                field("Pag-IBIG Contribution"; Rec."Pag-IBIG Contribution")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Pag-IBIG contribution.';
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the tax amount.';
                }
            }

            group(Audit)
            {
                Caption = 'Audit Information';
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the created date.';
                    Editable = false;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who created this transaction.';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Save)
            {
                ApplicationArea = All;
                Caption = 'Save';
                Image = Save;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Save the payroll transaction.';

                trigger OnAction()
                begin
                    if Rec.Insert(true) then
                        Message('Payroll transaction saved successfully.')
                    else
                        if Rec.Modify(true) then
                            Message('Payroll transaction updated successfully.')
                        else
                            Error('Failed to save payroll transaction.');
                end;
            }
            action(CalculatePayroll)
            {
                ApplicationArea = All;
                Caption = 'Calculate Payroll';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Calculate payroll amounts for this transaction.';

                trigger OnAction()
                var
                    PayrollCalc: Codeunit "Payroll Calculations";
                    EmployeeData: Record "Employee Data";
                    GrossPay: Decimal;
                    NetPay: Decimal;
                    SSSContribution: Decimal;
                    PhilHealthContribution: Decimal;
                    PagIBIGContribution: Decimal;
                    TaxAmount: Decimal;
                begin
                    // Get employee data
                    EmployeeData.Reset();
                    EmployeeData.SetRange(EmployeeNo, Rec."Employee No.");
                    if not EmployeeData.FindFirst() then
                        Error('Employee %1 not found.', Rec."Employee No.");

                    // Calculate gross pay (simplified - using basic rate)
                    GrossPay := EmployeeData.Rate;

                    // Calculate contributions
                    SSSContribution := PayrollCalc.CalculateSSS(GrossPay, Today);
                    PhilHealthContribution := PayrollCalc.CalculatePhilHealth(GrossPay, Today);
                    PagIBIGContribution := PayrollCalc.CalculatePagIBIG(GrossPay);

                    // Calculate tax
                    TaxAmount := PayrollCalc.CalculateTax(GrossPay, SSSContribution, PhilHealthContribution, PagIBIGContribution);

                    // Calculate net pay
                    NetPay := GrossPay - SSSContribution - PhilHealthContribution - PagIBIGContribution - TaxAmount;

                    // Update transaction
                    Rec."Gross Pay" := GrossPay;
                    Rec."Net Pay" := NetPay;
                    Rec."SSS Contribution" := SSSContribution;
                    Rec."PhilHealth Contribution" := PhilHealthContribution;
                    Rec."Pag-IBIG Contribution" := PagIBIGContribution;
                    Rec."Tax Amount" := TaxAmount;
                    Rec.Modify();

                    Message('Payroll calculated: Gross: %1, Net: %2', GrossPay, NetPay);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec."Payroll Period ID" = '' then
            Error('Payroll Period ID is required.');
        if Rec."Employee No." = '' then
            Error('Employee No. is required.');
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.UpdateEmployeeName();
    end;
}