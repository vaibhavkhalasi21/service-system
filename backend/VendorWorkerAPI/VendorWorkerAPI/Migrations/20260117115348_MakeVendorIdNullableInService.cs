using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace VendorWorkerAPI.Migrations
{
    /// <inheritdoc />
    public partial class MakeVendorIdNullableInService : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Payments_Applications_BookingId",
                table: "Payments");

            migrationBuilder.DropIndex(
                name: "IX_Payments_BookingId",
                table: "Payments");

            migrationBuilder.DropColumn(
                name: "RazorpayPaymentId",
                table: "Payments");

            migrationBuilder.DropColumn(
                name: "RazorpaySignature",
                table: "Payments");

            migrationBuilder.RenameColumn(
                name: "RazorpayOrderId",
                table: "Payments",
                newName: "PaymentMethod");

            migrationBuilder.AlterColumn<int>(
                name: "VendorId",
                table: "Payments",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<int>(
                name: "VendorId",
                table: "Applications",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "PaymentMethod",
                table: "Payments",
                newName: "RazorpayOrderId");

            migrationBuilder.AlterColumn<int>(
                name: "VendorId",
                table: "Payments",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddColumn<string>(
                name: "RazorpayPaymentId",
                table: "Payments",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "RazorpaySignature",
                table: "Payments",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "VendorId",
                table: "Applications",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Payments_BookingId",
                table: "Payments",
                column: "BookingId");

            migrationBuilder.AddForeignKey(
                name: "FK_Payments_Applications_BookingId",
                table: "Payments",
                column: "BookingId",
                principalTable: "Applications",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
