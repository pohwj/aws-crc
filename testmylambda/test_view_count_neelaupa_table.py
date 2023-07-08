import unittest
from unittest.mock import patch, MagicMock
import view_count_neelaupa_table 

class TestLambdaHandler(unittest.TestCase):
    @patch('view_count_neelaupa_table.table')
    def test_lambda_handler(self, mock_table):
        initial_views = 5
        mock_table.get_item.return_value = {
            'Item': {
                'id': '0',
                'views': initial_views
            }
        }

        # call the lambda handler function
        result = view_count_neelaupa_table.lambda_handler({}, {})
        # print(result)

        # assert the result
        self.assertEqual(result, initial_views + 1)
        mock_table.get_item.assert_called_once_with(Key={'id': '0'})
        mock_table.put_item.assert_called_once_with(Item={'id': '0', 'views': initial_views + 1})
    

        
if __name__ == '__main__':
    unittest.main()

