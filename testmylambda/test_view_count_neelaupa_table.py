import unittest
from unittest.mock import patch, MagicMock
from view_count_neelaupa_table import lambda_handler  

class TestLambdaHandler(unittest.TestCase):
    @patch('boto3.resource')
    def test_lambda_handler(self, mock_resource):
        mock_table = MagicMock()
        mock_resource.return_value.Table.return_value = mock_table
        mock_table.get_item.return_value = {
            'Item': {
                'id': '0',
                'views': 1
            }
        }
        mock_table.put_item.return_value = {}
        expected = 2
        actual = lambda_handler({}, {})
        self.assertEqual(expected, actual)
        mock_table.get_item.assert_called_once_with(Key={'id': '0'})
        mock_table.put_item.assert_called_once_with(Item={'id': '0', 'views': 2})
        
        

if __name__ == '__main__':
    unittest.main()

