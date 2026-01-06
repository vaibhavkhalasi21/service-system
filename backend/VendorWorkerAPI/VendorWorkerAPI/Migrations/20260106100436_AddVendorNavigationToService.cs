using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace VendorWorkerAPI.Migrations
{
    /// <inheritdoc />
    public partial class AddVendorNavigationToService : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Applications_Vendors_VendorId",
                table: "Applications");

            migrationBuilder.DropForeignKey(
                name: "FK_Applications_Workers_WorkerId",
                table: "Applications");

            migrationBuilder.DropForeignKey(
                name: "FK_Bookings_Users_WorkerId",
                table: "Bookings");

            migrationBuilder.DropForeignKey(
                name: "FK_Bookings_Vendors_VendorId",
                table: "Bookings");

            migrationBuilder.RenameColumn(
                name: "Password",
                table: "Workers",
                newName: "PasswordHash");

            migrationBuilder.RenameColumn(
                name: "Category",
                table: "Workers",
                newName: "Skill");

            migrationBuilder.RenameColumn(
                name: "WorkerId",
                table: "Workers",
                newName: "Id");

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Workers",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "Email",
                table: "Workers",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(150)",
                oldMaxLength: 150);

            migrationBuilder.AlterColumn<string>(
                name: "Skill",
                table: "Workers",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(100)",
                oldMaxLength: 100);

            migrationBuilder.AddColumn<string>(
                name: "Address",
                table: "Workers",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Role",
                table: "Workers",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddForeignKey(
                name: "FK_Applications_Vendors_VendorId",
                table: "Applications",
                column: "VendorId",
                principalTable: "Vendors",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Applications_Workers_WorkerId",
                table: "Applications",
                column: "WorkerId",
                principalTable: "Workers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Bookings_Users_WorkerId",
                table: "Bookings",
                column: "WorkerId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Bookings_Vendors_VendorId",
                table: "Bookings",
                column: "VendorId",
                principalTable: "Vendors",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Applications_Vendors_VendorId",
                table: "Applications");

            migrationBuilder.DropForeignKey(
                name: "FK_Applications_Workers_WorkerId",
                table: "Applications");

            migrationBuilder.DropForeignKey(
                name: "FK_Bookings_Users_WorkerId",
                table: "Bookings");

            migrationBuilder.DropForeignKey(
                name: "FK_Bookings_Vendors_VendorId",
                table: "Bookings");

            migrationBuilder.DropColumn(
                name: "Address",
                table: "Workers");

            migrationBuilder.DropColumn(
                name: "Role",
                table: "Workers");

            migrationBuilder.RenameColumn(
                name: "Skill",
                table: "Workers",
                newName: "Category");

            migrationBuilder.RenameColumn(
                name: "PasswordHash",
                table: "Workers",
                newName: "Password");

            migrationBuilder.RenameColumn(
                name: "Id",
                table: "Workers",
                newName: "WorkerId");

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Workers",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AlterColumn<string>(
                name: "Email",
                table: "Workers",
                type: "nvarchar(150)",
                maxLength: 150,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AlterColumn<string>(
                name: "Category",
                table: "Workers",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AddForeignKey(
                name: "FK_Applications_Vendors_VendorId",
                table: "Applications",
                column: "VendorId",
                principalTable: "Vendors",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Applications_Workers_WorkerId",
                table: "Applications",
                column: "WorkerId",
                principalTable: "Workers",
                principalColumn: "WorkerId",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Bookings_Users_WorkerId",
                table: "Bookings",
                column: "WorkerId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Bookings_Vendors_VendorId",
                table: "Bookings",
                column: "VendorId",
                principalTable: "Vendors",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
