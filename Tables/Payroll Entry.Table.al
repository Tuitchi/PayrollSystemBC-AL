table 50102 "Payroll Entry"
{
    Caption = 'Payroll Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; EntryNo; Code[20])
        {
            Caption = 'Entry No.';
        }
        field(2; EmployeeId; Code[20])
        {
            Caption = 'Employee Id.';
            TableRelation = "Employee Data".EmployeeId;
            // LookupPageId = "Payroll Employee List";

            trigger OnValidate()
            var
                EmployeeDataRec: Record "Employee Data";
            begin
                if EmployeeDataRec.Get(EmployeeId) then begin
                    // Use the rate from Employee Data as the default Gross Pay
                    GrossPay := EmployeeDataRec.Rate;
                    // Immediately calculate all deductions based on this gross pay
                    CalculateDeductions();
                end;
            end;
        }
        field(3; PeriodStart; Date)
        {
            Caption = 'Payroll Period Start';
        }
        field(4; PeriodEnd; Date)
        {
            Caption = 'Payroll Period End';
        }
        field(5; PostDate; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; GrossPay; Decimal)
        {
            Caption = 'Gross Pay';
            DecimalPlaces = 2;
            MinValue = 0;
            Editable = false;

            trigger OnValidate()
            begin
                CalculateDeductions();
            end;
        }
        field(7; SSSAmount; Decimal)
        {
            Caption = 'SSS Contribution';
            DecimalPlaces = 2;
            MinValue = 0;
            Editable = false;
        }
        field(8; PagibigAmt; Decimal)
        {
            Caption = 'Pag-IBIG Contribution';
            DecimalPlaces = 2;
            MinValue = 0;
            Editable = false;
        }
        field(9; PhilHealthAmt; Decimal)
        {
            Caption = 'PhilHealth Contribution';
            DecimalPlaces = 2;
            MinValue = 0;
            Editable = false;
        }
        field(10; TaxAmount; Decimal)
        {
            Caption = 'Withholding Tax';
            DecimalPlaces = 2;
            MinValue = 0;
            Editable = false;
        }
        field(11; OtherDed; Decimal)
        {
            Caption = 'Other Deductions';
            DecimalPlaces = 2;
            MinValue = 0;

            trigger OnValidate()
            begin
                CalculateNetPay();
            end;
        }
        field(12; NetPay; Decimal)
        {
            Caption = 'Net Pay';
            DecimalPlaces = 2;
            Editable = false;
        }
        field(13; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Draft,Released,Posted;
            OptionCaption = 'Draft,Released,Posted';
        }
        field(14; "PayDate"; Date)
        {
            Caption = 'Pay Date';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field kept for schema compatibility';
            Editable = false;
        }
        field(15; "PaymentDate"; Date)
        {
            Caption = 'Payment Date';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field kept for schema compatibility';
            Editable = false;
        }
        field(16; "PayFrequency"; Option)
        {
            Caption = 'Pay Frequency';
            OptionMembers = Monthly,"Semi-Monthly",Weekly,Daily;
            OptionCaption = 'Monthly,Semi-Monthly,Weekly,Daily';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field kept for schema compatibility';
            Editable = false;
        }
        field(99; EmployeeNo; Code[20])
        {
            Caption = 'Employee No. (legacy)';
            ObsoleteState = Removed;
            ObsoleteReason = 'Field kept for schema compatibility. Do not use.';
            Editable = false;
        }
        field(100; EmpName; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
    }

    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
        key(EmployeePeriod; EmployeeId, PeriodStart, PeriodEnd)
        {
        }
    }

    var
        PayrollSetup: Record "PH Payroll Setup";

    trigger OnInsert()
    begin
        if PostDate = 0D then
            PostDate := WorkDate();
    end;

    local procedure CalculateDeductions()
    var
        EmployeeDataRec: Record "Employee Data";
    begin
        // Get the employee data record
        if not EmployeeDataRec.Get(EmployeeId) then
            exit;

        // Calculate contributions based on gross pay and percentage rates from PH Payroll Setup
        // Employee IDs (SSS, PhilHealth, PagIBIG) come from Employee Data
        CalculateContributions();

        // Calculate tax using tax brackets from PH Payroll Setup
        CalculateTax();

        // Calculate net pay
        CalculateNetPay();
    end;

    local procedure CalculateContributions()
    var
        PayrollCalc: Codeunit "Payroll Calculations";
        CurrentDate: Date;
    begin
        CurrentDate := WorkDate();

        // Use codeunit for all calculations
        SSSAmount := PayrollCalc.CalculateSSS(GrossPay, CurrentDate);
        PhilHealthAmt := PayrollCalc.CalculatePhilHealth(GrossPay, CurrentDate);
        PagibigAmt := PayrollCalc.CalculatePagIBIG(GrossPay);
    end;

    local procedure CalculateTax()
    var
        PayrollCalc: Codeunit "Payroll Calculations";
    begin
        TaxAmount := PayrollCalc.CalculateTax(GrossPay, SSSAmount, PhilHealthAmt, PagibigAmt);
    end;

    local procedure CalculateNetPay()
    var
        PayrollCalc: Codeunit "Payroll Calculations";
    begin
        NetPay := PayrollCalc.CalculateNetPay(GrossPay, SSSAmount, PhilHealthAmt, PagibigAmt, TaxAmount, OtherDed);
    end;
}