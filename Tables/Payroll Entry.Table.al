table 50102 "Payroll Entry"
{
    Caption = 'Payroll Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; EntryNo; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
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
        SSS_Pct: Decimal;
        PagIBIG_Pct: Decimal;
        PhilHealth_Pct: Decimal;
    begin
        // Always try to get the latest setup
        if not PayrollSetup.Get('DEFAULT') then begin
            // If no setup exists, just create an empty one
            Clear(PayrollSetup);
            PayrollSetup.Init();
            PayrollSetup.PrimaryKey := 'DEFAULT';
            if PayrollSetup.Insert(true) then; // Use Insert(true) to suppress errors if insert fails
        end;

        // Always refresh the record to get latest values
        PayrollSetup.Find(); // Refresh the record

        // Get percentages from Payroll Setup
        SSS_Pct := PayrollSetup.SSS_Contribution_Pct;
        PagIBIG_Pct := PayrollSetup.PagIBIG_Contribution_Pct;
        PhilHealth_Pct := PayrollSetup.PhilHealth_Contribution_Pct;

        // Calculate contribution amounts based on percentages
        SSSAmount := Round(GrossPay * (SSS_Pct / 100), 0.01);
        PagibigAmt := Round(GrossPay * (PagIBIG_Pct / 100), 0.01);
        PhilHealthAmt := Round(GrossPay * (PhilHealth_Pct / 100), 0.01);
    end;

    local procedure CalculateTax()
    var
        TaxableIncome: Decimal;
    begin
        // Calculate taxable income (Gross pay minus contributions)
        TaxableIncome := GrossPay - SSSAmount - PagibigAmt - PhilHealthAmt;

        // Apply tax brackets
        if TaxableIncome <= PayrollSetup.Tax_Bracket1_Max then
            TaxAmount := TaxableIncome * (PayrollSetup.Tax_Rate1 / 100)
        else if TaxableIncome <= PayrollSetup.Tax_Bracket2_Max then
            TaxAmount := (PayrollSetup.Tax_Bracket1_Max * (PayrollSetup.Tax_Rate1 / 100)) +
                                ((TaxableIncome - PayrollSetup.Tax_Bracket1_Max) * (PayrollSetup.Tax_Rate2 / 100))
        else if TaxableIncome <= PayrollSetup.Tax_Bracket3_Max then
            TaxAmount := (PayrollSetup.Tax_Bracket1_Max * (PayrollSetup.Tax_Rate1 / 100)) +
                                ((PayrollSetup.Tax_Bracket2_Max - PayrollSetup.Tax_Bracket1_Max) * (PayrollSetup.Tax_Rate2 / 100)) +
                                ((TaxableIncome - PayrollSetup.Tax_Bracket2_Max) * (PayrollSetup.Tax_Rate3 / 100))
        else if TaxableIncome <= PayrollSetup.Tax_Bracket4_Max then
            TaxAmount := (PayrollSetup.Tax_Bracket1_Max * (PayrollSetup.Tax_Rate1 / 100)) +
                                ((PayrollSetup.Tax_Bracket2_Max - PayrollSetup.Tax_Bracket1_Max) * (PayrollSetup.Tax_Rate2 / 100)) +
                                ((PayrollSetup.Tax_Bracket3_Max - PayrollSetup.Tax_Bracket2_Max) * (PayrollSetup.Tax_Rate3 / 100)) +
                                ((TaxableIncome - PayrollSetup.Tax_Bracket3_Max) * (PayrollSetup.Tax_Rate4 / 100))
        else
            TaxAmount := (PayrollSetup.Tax_Bracket1_Max * (PayrollSetup.Tax_Rate1 / 100)) +
                                ((PayrollSetup.Tax_Bracket2_Max - PayrollSetup.Tax_Bracket1_Max) * (PayrollSetup.Tax_Rate2 / 100)) +
                                ((PayrollSetup.Tax_Bracket3_Max - PayrollSetup.Tax_Bracket2_Max) * (PayrollSetup.Tax_Rate3 / 100)) +
                                ((PayrollSetup.Tax_Bracket4_Max - PayrollSetup.Tax_Bracket3_Max) * (PayrollSetup.Tax_Rate4 / 100)) +
                                ((TaxableIncome - PayrollSetup.Tax_Bracket4_Max) * (PayrollSetup.Tax_Rate5 / 100));
    end;

    local procedure CalculateNetPay()
    var
        TotalContributions: Decimal;
        TotalDeductions: Decimal;
    begin
        // Calculate total government-mandated contributions
        TotalContributions := SSSAmount + PagibigAmt + PhilHealthAmt;

        // Calculate total deductions (contributions + tax + other deductions)
        TotalDeductions := TotalContributions + TaxAmount + OtherDed;

        // Net Pay = Gross Pay - All Deductions
        NetPay := GrossPay - TotalDeductions;

        // Ensure NetPay is not negative
        if NetPay < 0 then
            NetPay := 0;
    end;
}