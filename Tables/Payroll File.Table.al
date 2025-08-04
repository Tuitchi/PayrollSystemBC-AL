table 50112 "Payroll File"
{
    DataClassification = ToBeClassified;
    Caption = 'Payroll File';

    fields
    {
        field(1; "System ID"; Guid)
        {
            Caption = 'System ID';
            DataClassification = SystemMetadata;
        }
        field(2; "Payroll File ID"; Code[20])
        {
            Caption = 'Payroll File ID';
        }
        field(3; "Department ID"; Code[20])
        {
            Caption = 'Department ID';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DEPARTMENT'));
        }
        field(4; "Payroll Period Start"; Date)
        {
            Caption = 'Payroll Period Start';
        }
        field(5; "Payroll Period End"; Date)
        {
            Caption = 'Payroll Period End';
        }
        field(6; "Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(7; "Created Date"; Date)
        {
            Caption = 'Created Date';
        }
        field(8; "Created By"; Code[50])
        {
            Caption = 'Created By';
        }
        field(9; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = Draft,Processing,Completed,Cancelled;
            OptionCaption = 'Draft,Processing,Completed,Cancelled';
        }
        field(10; "Total Employees"; Integer)
        {
            Caption = 'Total Employees';
        }
    }

    keys
    {
        key(PK; "Payroll File ID")
        {
            Clustered = true;
        }
        key(SystemID; "System ID")
        {
        }
        key(Period; "Payroll Period Start", "Payroll Period End")
        {
        }
        key(Department; "Department ID")
        {
        }
        key(Status; "Status")
        {
        }
    }

    trigger OnInsert()
    begin
        "System ID" := CreateGuid();
        "Created Date" := Today;
        "Created By" := UserId;
        "Status" := "Status"::Draft;
    end;
}