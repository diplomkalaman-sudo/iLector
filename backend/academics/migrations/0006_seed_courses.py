from django.db import migrations


def seed_courses(apps, schema_editor):
    Course = apps.get_model("academics", "Course")
    for number in (1, 2, 3, 4):
        Course.objects.get_or_create(number=number)


def unseed_courses(apps, schema_editor):
    Course = apps.get_model("academics", "Course")
    Course.objects.filter(number__in=(1, 2, 3, 4)).delete()


class Migration(migrations.Migration):

    dependencies = [
        ("academics", "0005_alter_discipline_language"),
    ]

    operations = [
        migrations.RunPython(seed_courses, unseed_courses),
    ]
