/*
 * zen_info_sysfs.c
 *
 * Copyright (C) 2015 Brandon Berhent <bbedward@gmail.com>
 *
 * This provides the userspace with information related to the
 * zen kernel specifically. Primarly for facilitating with
 * kernel updates in the userspace.
 */

#include <linux/module.h>
#include <linux/kobject.h>
#include <linux/sysfs.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/sched.h>

struct kobject *zeninfo_kobj;
EXPORT_SYMBOL(zeninfo_kobj);

struct option
{
    char *name;
    int version_code;
};

struct option available_options[1] =
{
	{
		.name = "version",
		.version_code = CONFIG_ZEN_INFO_VERSION_CODE,
	},
};
EXPORT_SYMBOL(available_options);

static ssize_t cl_settings_show(struct kobject *kobj,
	struct kobj_attribute *attr, char *buf)
{
	int var;

	if (strcmp(attr->attr.name, "zen_version_code") == 0) {
		var = CONFIG_ZEN_INFO_VERSION_CODE;
	} else {
		return 0;
	}

	return sprintf(buf, "%d\n", var);
}

static ssize_t cl_settings_store(struct kobject *kobj,
	struct kobj_attribute *attr, const char *buf, size_t count)
{
	return count;
}

static struct kobj_attribute cl_zen_version_code =
	__ATTR(zen_version_code, 0666, cl_settings_show,
		cl_settings_store);

static struct attribute *zen_info_attrs[] = {
	&cl_zen_version_code.attr, NULL,
};

static struct attribute_group zen_info_option_group = {
	.attrs = zen_info_attrs,
};

int init_sysfs_interface(void)
{
	int ret;
	/* Create /sys/kernel/zen_info/ */
	zeninfo_kobj = kobject_create_and_add("zen_info", kernel_kobj);
	if (zeninfo_kobj == NULL) {
		printk(KERN_ERR "zen_info: subsystem_register failed.\n");
		return -ENOMEM;
	} else {
		/* Add zen_version_code */
		ret = sysfs_create_group(zeninfo_kobj, &zen_info_option_group);
		printk(KERN_INFO "zen_info: sysfs interface initiated.\n");
	}

	return ret;
}

void cleanup_sysfs_interface(void)
{
	kobject_put(zeninfo_kobj);
}

static int zen_info_sysfs_init(void)
{
	int ret;

	ret = init_sysfs_interface();
	if (ret)
		goto out_error;

	return 0;

out_error:
	return ret;
}

static void zen_info_sysfs_exit(void)
{
	cleanup_sysfs_interface();
}

module_init(zen_info_sysfs_init);
module_exit(zen_info_sysfs_exit);
MODULE_VERSION("2.0");
MODULE_LICENSE("GPL v2");
MODULE_AUTHOR("Brandon Berhent <bbedward@gmail.com>");
