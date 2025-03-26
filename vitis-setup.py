# Add package: Vitis Python CLI
import vitis

# Create a Vitis client object
client = vitis.create_client()

# Set Vitis Workspace
client.set_workspace(path="./")

# Defining names for platform, application_component and
plat_name="tpm_platform"
comp_name="tpm_application"
 
# Create and build platform component for vck190 for standalone_psv_cortexa72
platform_obj=client.create_platform_component(name=plat_name, hw_design="hw/tpm_hw/tpm_design_wrapper.xsa", cpu="psu_cortexa53_0", os="standalone")
platform_obj.build()

# This returns the platform xpfm path
platform_xpfm=client.find_platform_in_repos(plat_name)

# Create and build application component
comp = client.create_app_component(name=comp_name, platform = platform_xpfm, domain = "standalone_psu_cortexa53_0", template = "hello_world")
comp.build()

# Create system project
sys_proj = client.create_sys_project(name="system_project", platform=platform_xpfm, template="empty_accelerated_application")
# Add application component to the system project
sys_proj_comp = sys_proj.add_component(name="hello_world")
# Build system project
sys_proj_comp.build()

vitis.dispose()