table 50103 "SSS Contribution"
{
    DataClassification = ToBeClassified;
    Caption = 'SSS Contribution Table';

    fields
    {
        field(1; "Entry No."; Code[20])
        {
            Caption = 'Entry No.';
        }
        field(2; "LowRate"; Decimal)
        {
            Caption = 'Low Rate';
            DecimalPlaces = 2;
        }
        field(3; "HighRate"; Decimal)
        {
            Caption = 'High Rate';
            DecimalPlaces = 2;
        }
        field(4; "MSC"; Decimal)
        {
            Caption = 'Monthly Salary Credit';
            DecimalPlaces = 2;
        }
        field(5; "EmployerShare"; Decimal)
        {
            Caption = 'SS Employer Share';
            DecimalPlaces = 2;
        }
        field(6; "EmployeeShare"; Decimal)
        {
            Caption = 'SS Employee Share';
            DecimalPlaces = 2;
        }
        field(7; "ECC"; Decimal)
        {
            Caption = 'EC Employer Share';
            DecimalPlaces = 2;
        }
        field(8; "TotalContribution"; Decimal)
        {
            Caption = 'Total Contribution';
            DecimalPlaces = 2;
        }
        field(9; "EffectiveDate"; Date)
        {
            Caption = 'Effective Date';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(SalaryRange; "LowRate", "HighRate", "EffectiveDate")
        {
        }
    }
}