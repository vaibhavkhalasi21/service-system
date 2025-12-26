using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace VendorWorkerAPI.Migrations
{
    /// <inheritdoc />
    public partial class UpdateWorkerJwt : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_Workers",
                table: "Workers");

            migrationBuilder.RenameColumn(
                name: "Password",
                table: "Workers",
                newName: "Role");

            migrationBuilder.RenameColumn(
                name: "Category",
                table: "Workers",
                newName: "PasswordHash");

            migrationBuilder.RenameColumn(
                name: "WorkerId",
                table: "Workers",
                newName: "VendorId");

            migrationBuilder.AlterColumn<int>(
                name: "VendorId",
                table: "Workers",
                type: "int",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int")
                .OldAnnotation("SqlServer:Identity", "1, 1");

            migrationBuilder.AddColumn<int>(
                name: "Id",
                table: "Workers",
                type: "int",
                nullable: false,
                defaultValue: 0)
                .Annotation("SqlServer:Identity", "1, 1");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Workers",
                table: "Workers",
                column: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_Workers",
                table: "Workers");

            migrationBuilder.DropColumn(
                name: "Id",
                table: "Workers");

            migrationBuilder.RenameColumn(
                name: "VendorId",
                table: "Workers",
                newName: "WorkerId");

            migrationBuilder.RenameColumn(
                name: "Role",
                table: "Workers",
                newName: "Password");

            migrationBuilder.RenameColumn(
                name: "PasswordHash",
                table: "Workers",
                newName: "Category");

            migrationBuilder.AlterColumn<int>(
                name: "WorkerId",
                table: "Workers",
                type: "int",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int")
                .Annotation("SqlServer:Identity", "1, 1");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Workers",
                table: "Workers",
                column: "WorkerId");
        }
    }
}
