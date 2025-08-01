table 50104 "PhilHealth Contribution"
{
    DataClassification = ToBeClassified;
    Caption = 'PhilHealth Contribution Table';

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
        field(4; "PremiumRate"; Decimal)
        {
            Caption = 'Premium Rate (%)';
            DecimalPlaces = 2;
        }
        field(5; "Monthly Premium"; Decimal)
        {
            Caption = 'Monthly Premium';
            DecimalPlaces = 2;
        }
        field(6; "EmployeeShare"; Decimal)
        {
            Caption = 'Employee Share';
            DecimalPlaces = 2;
        }
        field(7; "EmployerShare"; Decimal)
        {
            Caption = 'Employer Share';
            DecimalPlaces = 2;
        }
        field(8; "EffectiveDate"; Date)
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