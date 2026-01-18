using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace VendorWorkerAPI.Migrations
{
    /// <inheritdoc />
    public partial class RemoveWorkerSkill : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
           // migrationBuilder.DropColumn(
             //   name: "Skill",
               // table: "Workers");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // migrationBuilder.AddColumn<string>(
               // name: "Skill",
               // table: "Workers",
               // type: "nvarchar(max)",
               // nullable: false,
               // defaultValue: "");
        }
    }
}
