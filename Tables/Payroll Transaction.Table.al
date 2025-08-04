table 50115 "Payroll Transaction"
{
    DataClassification = ToBeClassified;
    Caption = 'Payroll Transaction';

    fields
    {
        field(1; "System ID"; Guid)
        {
            Caption = 'System ID';
            DataClassification = SystemMetadata;
        }
        field(2; "Payroll Period ID"; Code[20])
        {
            Caption = 'Payroll Period ID';
            TableRelation = "Payroll File"."Payroll File ID";
        }
        field(3; "Department ID"; Code[20])
        {
            Caption = 'Department ID';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DEPARTMENT'));
        }
        field(4; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee."No.";
        }
        field(5; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(6; "Gross Pay"; Decimal)
        {
            Caption = 'Gross Pay';
            DecimalPlaces = 2;
        }
        field(7; "Net Pay"; Decimal)
        {
            Caption = 'Net Pay';
            DecimalPlaces = 2;
        }
        field(8; "SSS Contribution"; Decimal)
        {
            Caption = 'SSS Contribution';
            DecimalPlaces = 2;
        }
        field(9; "PhilHealth Contribution"; Decimal)
        {
            Caption = 'PhilHealth Contribution';
            DecimalPlaces = 2;
        }
        field(10; "Pag-IBIG Contribution"; Decimal)
        {
            Caption = 'Pag-IBIG Contribution';
            DecimalPlaces = 2;
        }
        field(11; "Tax Amount"; Decimal)
        {
            Caption = 'Tax Amount';
            DecimalPlaces = 2;
        }
        field(12; "Created Date"; Date)
        {
            Caption = 'Created Date';
        }
        field(13; "Created By"; Code[50])
        {
            Caption = 'Created By';
        }
        field(14; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = Draft,Processed,Completed;
            OptionCaption = 'Draft,Processed,Completed';
        }
    }

    keys
    {
        key(PK; "System ID")
        {
            Clustered = true;
        }
        key(PayrollPeriod; "Payroll Period ID")
        {
        }
        key(Employee; "Employee No.")
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



    procedure UpdateEmployeeName()
    var
        EmployeeData: Record Employee;
    begin
        if "Employee No." <> '' then begin
            EmployeeData.Reset();
            EmployeeData.SetRange("No.", "Employee No.");
            if EmployeeData.FindFirst() then
                "Employee Name" := EmployeeData."First Name" + ' ' + EmployeeData."Last Name"
            else
                "Employee Name" := '';
        end else
            "Employee Name" := '';
    end;
}