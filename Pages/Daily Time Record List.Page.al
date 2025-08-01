page 50107 "Daily Time Record List"
{
    ApplicationArea = All;
    Caption = 'Daily Time Records';
    PageType = List;
    SourceTable = "Daily Time Record";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the entry number.';
                    Editable = false;
                }
                field("EmployeeId"; Rec."EmployeeId")
                {
                    ToolTip = 'Specifies the Employee ID.';
                }
                field("EmployeeName"; EmployeeName)
                {
                    Caption = 'Employee Name';
                    ToolTip = 'Specifies the full name of the employee.';
                    Editable = false;
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the attendance date.';
                }
                field("TimeIn"; Rec."TimeIn")
                {
                    ToolTip = 'Specifies the time in.';
                }
                field("TimeOut"; Rec."TimeOut")
                {
                    ToolTip = 'Specifies the time out.';
                }
                field("OTHour"; Rec."OTHour")
                {
                    ToolTip = 'Specifies the overtime hours.';
                }
                field("OTapprove"; Rec."OTapprove")
                {
                    ToolTip = 'Specifies if overtime is approved.';
                }
            }
        }
    }

    var
        EmployeeName: Text;

    trigger OnAfterGetRecord()
    var
        EmployeeRec: Record Employee;
    begin
        EmployeeName := '';
        if EmployeeRec.Get(Rec.EmployeeId) then
            EmployeeName := EmployeeRec."First Name" + ' ' + EmployeeRec."Last Name";
    end;
}