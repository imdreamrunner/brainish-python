import importlib

__author__ = "imdreamrunner"
__email__ = "imdreamrunner@gmail.com"


def to_bash(janish):
    bash = ""
    if isinstance(janish, list):
        for j in janish:
            bash += to_bash(j)
    else:
        assert "illusion" in janish
        illusion_name = janish["illusion"]
        import illusions
        if illusion_name in illusions.__all__:
            module_to_call = importlib.import_module("." + illusion_name, "core.illusions")
            bash += module_to_call.to_bash(janish)
    return bash


def compile_janish(janish):
    try:
        return "#!/bin/bash\n" + to_bash(janish)
    except AssertionError as e:
        return "ERROR: Program contains error.\n" + str(e)
    except Exception as e:
        return "Unknown error:\n" + str(e)


if __name__ == "__main__":
    test = {
        "illusion": "echo"
    }
    print(compile_janish(test))
