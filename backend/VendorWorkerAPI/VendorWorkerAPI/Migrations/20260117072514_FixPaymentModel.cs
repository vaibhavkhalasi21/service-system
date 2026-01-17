using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace VendorWorkerAPI.Migrations
{
    /// <inheritdoc />
    public partial class FixPaymentModel : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "ReleasedAt",
                table: "Payments",
                type: "datetime2",
                nullable: true);

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

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Payments_Applications_BookingId",
                table: "Payments");

            migrationBuilder.DropIndex(
                name: "IX_Payments_BookingId",
                table: "Payments");

            migrationBuilder.DropColumn(
                name: "ReleasedAt",
                table: "Payments");
        }
    }
}
