# from text_generation import Client
from transformers import AutoTokenizer


def default_chat_template(self):
    """
    This template formats inputs in the standard ChatML format. See
    https://github.com/openai/openai-python/blob/main/chatml.md
    """
    return (
        "{% for message in messages %}"
        "{{'<|im_start|>' + message['role'] + '\n' + message['content'] + '<|im_end|>' + '\n'}}"
        "{% endfor %}"
    )

def get_template(model):
    tokenizer = AutoTokenizer.from_pretrained(model)

    # This template formats inputs in the standard ChatML format. See
    # https://github.com/openai/openai-python/blob/main/chatml.md
    chat_template = tokenizer.chat_template or tokenizer.default_chat_template
    special_tokens_map = tokenizer.special_tokens_map

    # template = {
    #     "special_tokens_map" : special_tokens_map,
    #     "chat_template" : chat_template,
    # }


    import json
    # print(json.dumps(template))


    full_chat_template = "\n".join(["{%- set "+k+" = "+json.dumps(v)+" -%}" for k,v in special_tokens_map.items()] + [chat_template])
        

    print(full_chat_template)
    # dict(messages=conversation, **self.special_tokens_map)

print(dict(a=1) | dict(a=2))

get_template("HuggingFaceH4/zephyr-7b-alpha")