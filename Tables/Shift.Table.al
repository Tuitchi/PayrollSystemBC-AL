table 50110 "Shift"
{
    DataClassification = ToBeClassified;
    Caption = 'Shift';

    fields
    {
        field(1; "Shift Code"; Code[10])
        {
            Caption = 'Shift Code';
        }
        field(2; "Shift Name"; Text[50])
        {
            Caption = 'Shift Name';
        }
        field(3; "Start Time"; Time)
        {
            Caption = 'Start Time';
        }
        field(4; "End Time"; Time)
        {
            Caption = 'End Time';
        }
        field(7; "Working Hours"; Decimal)
        {
            Caption = 'Working Hours';
            DecimalPlaces = 2;
        }
        field(8; "Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(9; "Is Active"; Boolean)
        {
            Caption = 'Is Active';
        }
    }

    keys
    {
        key(PK; "Shift Code")
        {
            Clustered = true;
        }
    }
}